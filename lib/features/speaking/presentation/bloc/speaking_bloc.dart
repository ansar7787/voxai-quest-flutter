import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/domain/usecases/update_user_rewards.dart';
import '../../domain/entities/speaking_quest.dart';
import '../../domain/usecases/get_speaking_quest.dart';
import '../../../../core/domain/entities/game_quest.dart';
import '../../../../core/network/network_info.dart';

// --- EVENTS ---
abstract class SpeakingEvent {}

class FetchSpeakingQuests extends SpeakingEvent {
  final dynamic gameType;
  final int level;
  FetchSpeakingQuests({required this.gameType, required this.level});
}

class SubmitAnswer extends SpeakingEvent {
  final bool isCorrect;
  SubmitAnswer(this.isCorrect);
}

class NextQuestion extends SpeakingEvent {}

class RestartLevel extends SpeakingEvent {}

class SpeakingHintUsed extends SpeakingEvent {}

class RestoreLife extends SpeakingEvent {}

class AddHint extends SpeakingEvent {
  final int count;
  AddHint(this.count);
}

// --- STATES ---
abstract class SpeakingState {}

class SpeakingInitial extends SpeakingState {}

class SpeakingLoading extends SpeakingState {}

class SpeakingLoaded extends SpeakingState {
  final List<SpeakingQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  SpeakingQuest get currentQuest => quests[currentIndex];

  SpeakingLoaded({
    required this.quests,
    required this.currentIndex,
    required this.livesRemaining,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  SpeakingLoaded copyWith({
    List<SpeakingQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return SpeakingLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect, // Nullable override
      hintUsed: hintUsed ?? this.hintUsed,
    );
  }
}

class SpeakingError extends SpeakingState {
  final String message;
  SpeakingError(this.message);
}

class SpeakingGameComplete extends SpeakingState {
  final int xpEarned;
  final int coinsEarned;
  SpeakingGameComplete({required this.xpEarned, required this.coinsEarned});
}

class SpeakingGameOver extends SpeakingState {
  final List<SpeakingQuest> quests;
  final int currentIndex;
  SpeakingGameOver({required this.quests, required this.currentIndex});
}

// --- BLOC ---
class SpeakingBloc extends Bloc<SpeakingEvent, SpeakingState> {
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

  SpeakingBloc({
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
  }) : super(SpeakingInitial()) {
    on<FetchSpeakingQuests>((event, emit) async {
      currentGameType = event.gameType is GameSubtype
          ? (event.gameType as GameSubtype).name
          : event.gameType.toString();
      currentLevel = event.level;

      emit(SpeakingLoading());
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        emit(
          SpeakingError("No internet connection. Please check your network."),
        );
        return;
      }

      final GameSubtype subtype = event.gameType is GameSubtype
          ? event.gameType
          : GameSubtype.values.firstWhere(
              (s) => s.name == event.gameType.toString(),
              orElse: () => GameSubtype.repeatSentence,
            );

      final result = await getQuest(
        QuestParams(gameType: subtype, level: event.level),
      );

      result.fold((failure) => emit(SpeakingError(failure.message)), (quests) {
        if (quests.isEmpty) {
          emit(SpeakingError("Check back later for new quests!"));
        } else {
          // ENSURE STICKY 3 QUESTIONS PER LEVEL (Optimized for production)
          final limitedQuests = quests.take(3).toList();
          emit(
            SpeakingLoaded(
              quests: limitedQuests,
              currentIndex: 0,
              livesRemaining: 3,
            ),
          );
        }
      });
    });

    on<RestartLevel>((event, emit) {
      emit(SpeakingInitial());
    });

    on<SpeakingHintUsed>(_onUseHint);
    on<RestoreLife>(_onRestoreLife);
    on<AddHint>(_onAddHint);

    on<SubmitAnswer>((event, emit) async {
      final currentState = state;
      if (currentState is! SpeakingLoaded) return;

      int newLives = currentState.livesRemaining;
      if (!event.isCorrect) {
        newLives--;
        await soundService.playWrong();
        await hapticService.error();
      } else {
        await soundService.playCorrect();
        await hapticService.success();
      }

      emit(
        currentState.copyWith(
          livesRemaining: newLives,
          lastAnswerCorrect: event.isCorrect,
        ),
      );

      if (newLives <= 0) {
        emit(
          SpeakingGameOver(
            quests: currentState.quests,
            currentIndex: currentState.currentIndex,
          ),
        );
      }
    });

    on<NextQuestion>((event, emit) async {
      final currentState = state;
      if (currentState is! SpeakingLoaded) return;

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
          await soundService.playLevelComplete();
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
            SpeakingGameComplete(xpEarned: totalXp, coinsEarned: totalCoins),
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
            if (awardBadge != null) await awardBadge!('speaking_master');
          }
        }
      } else {
        // Just clear the overlay if it was wrong but they still have lives
        emit(currentState.copyWith(lastAnswerCorrect: null));
      }
    });
  }

  Future<void> _onUseHint(
    SpeakingHintUsed event,
    Emitter<SpeakingState> emit,
  ) async {
    if (state is SpeakingLoaded) {
      final s = state as SpeakingLoaded;
      if (s.hintUsed) return;

      final success = await useHint();
      if (success) {
        emit(s.copyWith(hintUsed: true));
        hapticService.selection();
      }
    }
  }

  void _onRestoreLife(RestoreLife event, Emitter<SpeakingState> emit) {
    if (state is SpeakingGameOver) {
      final s = state as SpeakingGameOver;
      emit(
        SpeakingLoaded(
          quests: s.quests,
          currentIndex: s.currentIndex,
          livesRemaining: 1,
          lastAnswerCorrect: null,
          hintUsed: false,
        ),
      );
    }
  }

  void _onAddHint(AddHint event, Emitter<SpeakingState> emit) {
    // Logic to update user count if needed
  }
}
