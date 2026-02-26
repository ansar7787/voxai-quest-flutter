import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/domain/usecases/update_user_rewards.dart';
import '../../domain/entities/accent_quest.dart';
import '../../../../core/domain/entities/game_quest.dart';
import '../../../../core/network/network_info.dart';

// --- EVENTS ---
abstract class AccentEvent {}

class FetchAccentQuests extends AccentEvent {
  final dynamic gameType;
  final int level;
  FetchAccentQuests({required this.gameType, required this.level});
}

class SubmitAnswer extends AccentEvent {
  final bool isCorrect;
  SubmitAnswer(this.isCorrect);
}

class NextQuestion extends AccentEvent {}

class RestartLevel extends AccentEvent {}

class AccentHintUsed extends AccentEvent {}

class RestoreLife extends AccentEvent {}

// --- STATES ---
abstract class AccentState {}

class AccentInitial extends AccentState {}

class AccentLoading extends AccentState {}

class AccentLoaded extends AccentState {
  final List<AccentQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  AccentQuest get currentQuest => quests[currentIndex];

  AccentLoaded({
    required this.quests,
    required this.currentIndex,
    required this.livesRemaining,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  AccentLoaded copyWith({
    List<AccentQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return AccentLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect, // Nullable override
      hintUsed: hintUsed ?? this.hintUsed,
    );
  }
}

class AccentError extends AccentState {
  final String message;
  AccentError(this.message);
}

class AccentGameComplete extends AccentState {
  final int xpEarned;
  final int coinsEarned;
  AccentGameComplete({required this.xpEarned, required this.coinsEarned});
}

class AccentGameOver extends AccentState {
  final List<AccentQuest> quests;
  final int currentIndex;
  AccentGameOver({required this.quests, required this.currentIndex});
}

// --- BLOC ---
class AccentBloc extends Bloc<AccentEvent, AccentState> {
  final dynamic getQuest;
  final dynamic updateUserCoins;
  final dynamic updateUserRewards;
  final dynamic updateCategoryStats;
  final dynamic updateUnlockedLevel;
  final dynamic awardBadge;
  final dynamic soundService;
  final dynamic hapticService;
  final dynamic useHint;
  final NetworkInfo networkInfo;

  String? currentGameType;
  int? currentLevel;

  AccentBloc({
    this.getQuest,
    this.updateUserCoins,
    this.updateUserRewards,
    this.updateCategoryStats,
    this.updateUnlockedLevel,
    this.awardBadge,
    this.soundService,
    this.hapticService,
    this.useHint,
    required this.networkInfo,
  }) : super(AccentInitial()) {
    on<FetchAccentQuests>((event, emit) async {
      currentGameType = event.gameType is GameSubtype
          ? (event.gameType as GameSubtype).name
          : event.gameType.toString();
      currentLevel = event.level;

      emit(AccentLoading());
      try {
        final isConnected = await networkInfo.isConnected;
        if (!isConnected) {
          emit(
            AccentError("No internet connection. Please check your network."),
          );
          return;
        }

        if (getQuest == null) {
          emit(AccentError("UseCase dependency not provided"));
          return;
        }

        final List<AccentQuest> quests = [];
        try {
          final result = await getQuest!(event.gameType, event.level);
          if (result != null && result is List<AccentQuest>) {
            quests.addAll(result);
          }
        } catch (e) {
          try {
            final result = await getQuest!(event.gameType);
            if (result != null && result is List<AccentQuest>) {
              quests.addAll(result);
            }
          } catch (_) {}
        }

        if (quests.isEmpty) {
          emit(AccentError("We couldn't find any quests for this level yet."));
          return;
        }

        if (quests.isEmpty) {
          emit(AccentError("Check back later for new quests!"));
        } else {
          // ENSURE STICKY 3 QUESTIONS PER LEVEL
          final limitedQuests = quests.take(3).toList();
          emit(
            AccentLoaded(
              quests: limitedQuests,
              currentIndex: 0,
              livesRemaining: 3, // Standard 3 lives
            ),
          );
        }
      } catch (e) {
        emit(AccentError("Failed to fetch quests: $e"));
      }
    });

    on<SubmitAnswer>((event, emit) async {
      final currentState = state;
      if (currentState is! AccentLoaded) return;

      int newLives = currentState.livesRemaining;
      if (!event.isCorrect) {
        newLives--;
        if (soundService != null) await soundService.playWrong();
        if (hapticService != null) await hapticService.error();
      } else {
        if (soundService != null) await soundService.playCorrect();
        if (hapticService != null) await hapticService.success();
      }

      emit(
        currentState.copyWith(
          livesRemaining: newLives,
          lastAnswerCorrect: event.isCorrect,
        ),
      );

      if (newLives <= 0) {
        emit(
          AccentGameOver(
            quests: currentState.quests,
            currentIndex: currentState.currentIndex,
          ),
        );
      }
    });

    on<NextQuestion>((event, emit) async {
      final currentState = state;
      if (currentState is! AccentLoaded) return;

      if (currentState.lastAnswerCorrect == true) {
        if (currentState.currentIndex + 1 < currentState.quests.length) {
          emit(
            currentState.copyWith(
              currentIndex: currentState.currentIndex + 1,
              lastAnswerCorrect: null,
              hintUsed: false,
            ),
          );
        } else {
          if (soundService != null) await soundService.playLevelComplete();
          // Calculate rewards
          int totalXp = currentState.quests.fold(
            0,
            (sum, q) => sum + q.xpReward,
          );
          int totalCoins = currentState.quests.fold(
            0,
            (sum, q) => sum + q.coinReward,
          );

          emit(AccentGameComplete(xpEarned: totalXp, coinsEarned: totalCoins));

          // PERSISTENCE
          if (currentGameType != null && currentLevel != null) {
            if (updateUserRewards != null) {
              await updateUserRewards!(
                UpdateUserRewardsParams(
                  gameType: currentGameType!,
                  level: currentLevel!,
                  xpIncrease: 10,
                  coinIncrease: 10,
                ),
              );
            }
            if (updateCategoryStats != null) {
              await updateCategoryStats!(currentGameType!, true);
            }
            if (awardBadge != null) await awardBadge!('accent_master');
          }
        }
      } else {
        // Just clear the overlay if it was wrong but they still have lives
        emit(currentState.copyWith(lastAnswerCorrect: null));
      }
    });

    on<AccentHintUsed>((event, emit) async {
      if (state is AccentLoaded) {
        final s = state as AccentLoaded;
        if (s.hintUsed) return;

        if (useHint != null) {
          final success = await useHint!();
          if (success) {
            emit(s.copyWith(hintUsed: true));
            if (hapticService != null) hapticService.selection();
          }
        }
      }
    });

    on<RestoreLife>((event, emit) {
      if (state is AccentGameOver) {
        final s = state as AccentGameOver;
        emit(
          AccentLoaded(
            quests: s.quests,
            currentIndex: s.currentIndex,
            livesRemaining: 1,
            lastAnswerCorrect: null,
            hintUsed: false,
          ),
        );
      }
    });

    on<RestartLevel>((event, emit) {
      emit(AccentInitial());
    });
  }
}
