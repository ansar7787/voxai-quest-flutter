import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/domain/usecases/update_user_rewards.dart';
import '../../domain/entities/roleplay_quest.dart';
import '../../../../core/domain/entities/game_quest.dart';
import '../../../../core/network/network_info.dart';

// --- EVENTS ---
abstract class RoleplayEvent {}

class FetchRoleplayQuests extends RoleplayEvent {
  final dynamic gameType;
  final int level;
  FetchRoleplayQuests({required this.gameType, required this.level});
}

class SubmitAnswer extends RoleplayEvent {
  final bool isCorrect;
  SubmitAnswer(this.isCorrect);
}

class NextQuestion extends RoleplayEvent {}

class RestartLevel extends RoleplayEvent {}

class RoleplayHintUsed extends RoleplayEvent {}

class RestoreLife extends RoleplayEvent {}

// --- STATES ---
abstract class RoleplayState {}

class RoleplayInitial extends RoleplayState {}

class RoleplayLoading extends RoleplayState {}

class RoleplayLoaded extends RoleplayState {
  final List<RoleplayQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  RoleplayQuest get currentQuest => quests[currentIndex];

  RoleplayLoaded({
    required this.quests,
    required this.currentIndex,
    required this.livesRemaining,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  RoleplayLoaded copyWith({
    List<RoleplayQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return RoleplayLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect, // Nullable override
      hintUsed: hintUsed ?? this.hintUsed,
    );
  }
}

class RoleplayError extends RoleplayState {
  final String message;
  RoleplayError(this.message);
}

class RoleplayGameComplete extends RoleplayState {
  final int xpEarned;
  final int coinsEarned;
  RoleplayGameComplete({required this.xpEarned, required this.coinsEarned});
}

class RoleplayGameOver extends RoleplayState {
  final List<RoleplayQuest> quests;
  final int currentIndex;
  RoleplayGameOver({required this.quests, required this.currentIndex});
}

// --- BLOC ---
class RoleplayBloc extends Bloc<RoleplayEvent, RoleplayState> {
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

  RoleplayBloc({
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
  }) : super(RoleplayInitial()) {
    on<FetchRoleplayQuests>((event, emit) async {
      currentGameType = event.gameType is GameSubtype
          ? (event.gameType as GameSubtype).name
          : event.gameType.toString();
      currentLevel = event.level;

      emit(RoleplayLoading());
      try {
        final isConnected = await networkInfo.isConnected;
        if (!isConnected) {
          emit(
            RoleplayError("No internet connection. Please check your network."),
          );
          return;
        }

        if (getQuest == null) {
          emit(RoleplayError("UseCase dependency not provided"));
          return;
        }

        final List<RoleplayQuest> quests = [];
        try {
          final result = await getQuest!(event.gameType, event.level);
          if (result != null && result is List<RoleplayQuest>) {
            quests.addAll(result);
          }
        } catch (e) {
          try {
            final result = await getQuest!(event.gameType);
            if (result != null && result is List<RoleplayQuest>) {
              quests.addAll(result);
            }
          } catch (_) {}
        }

        if (quests.isEmpty) {
          emit(
            RoleplayError("We couldn't find any quests for this level yet."),
          );
        } else {
          // ENSURE STICKY 3 QUESTIONS PER LEVEL
          final limitedQuests = quests.take(3).toList();
          emit(
            RoleplayLoaded(
              quests: limitedQuests,
              currentIndex: 0,
              livesRemaining: 3, // Standard 3 lives
            ),
          );
        }
      } catch (e) {
        emit(RoleplayError("Failed to fetch quests: $e"));
      }
    });

    on<SubmitAnswer>((event, emit) async {
      final currentState = state;
      if (currentState is! RoleplayLoaded) return;

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
          RoleplayGameOver(
            quests: currentState.quests,
            currentIndex: currentState.currentIndex,
          ),
        );
      }
    });

    on<NextQuestion>((event, emit) async {
      final currentState = state;
      if (currentState is! RoleplayLoaded) return;

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

          emit(
            RoleplayGameComplete(xpEarned: totalXp, coinsEarned: totalCoins),
          );

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
            if (awardBadge != null) await awardBadge!('roleplay_master');
          }
        }
      } else {
        // Just clear the overlay if it was wrong but they still have lives
        emit(currentState.copyWith(lastAnswerCorrect: null));
      }
    });

    on<RoleplayHintUsed>((event, emit) async {
      if (state is RoleplayLoaded) {
        final s = state as RoleplayLoaded;
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
      if (state is RoleplayGameOver) {
        final s = state as RoleplayGameOver;
        emit(
          RoleplayLoaded(
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
      emit(RoleplayInitial());
    });
  }
}
