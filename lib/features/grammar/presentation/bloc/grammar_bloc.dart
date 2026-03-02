import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/grammar_quest.dart';
import '../../../../core/domain/entities/game_quest.dart';
import '../../../../core/network/network_info.dart';

// --- EVENTS ---
abstract class GrammarEvent {}

class FetchGrammarQuests extends GrammarEvent {
  final dynamic gameType;
  final int level;
  FetchGrammarQuests({required this.gameType, required this.level});
}

class SubmitAnswer extends GrammarEvent {
  final bool isCorrect;
  SubmitAnswer(this.isCorrect);
}

class NextQuestion extends GrammarEvent {}

class RestartLevel extends GrammarEvent {}

class GrammarHintUsed extends GrammarEvent {}

class RestoreLife extends GrammarEvent {}

// --- STATES ---
abstract class GrammarState {}

class GrammarInitial extends GrammarState {}

class GrammarLoading extends GrammarState {}

class GrammarLoaded extends GrammarState {
  final List<GrammarQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  final bool hintUsed;

  GrammarQuest get currentQuest => quests[currentIndex];

  GrammarLoaded({
    required this.quests,
    required this.currentIndex,
    required this.livesRemaining,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  GrammarLoaded copyWith({
    List<GrammarQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return GrammarLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect, // Nullable override
      hintUsed: hintUsed ?? this.hintUsed,
    );
  }
}

class GrammarError extends GrammarState {
  final String message;
  GrammarError(this.message);
}

class GrammarGameComplete extends GrammarState {
  final int xpEarned;
  final int coinsEarned;
  GrammarGameComplete({required this.xpEarned, required this.coinsEarned});
}

class GrammarGameOver extends GrammarState {
  final List<GrammarQuest> quests;
  final int currentIndex;

  GrammarGameOver({required this.quests, required this.currentIndex});
}

// --- BLOC ---
class GrammarBloc extends Bloc<GrammarEvent, GrammarState> {
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

  GrammarBloc({
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
  }) : super(GrammarInitial()) {
    on<FetchGrammarQuests>((event, emit) async {
      currentGameType = event.gameType is GameSubtype
          ? (event.gameType as GameSubtype).name
          : event.gameType.toString();
      currentLevel = event.level;

      emit(GrammarLoading());
      try {
        if (getQuest == null) {
          emit(GrammarError("UseCase dependency not provided"));
          return;
        }

        final List<GrammarQuest> quests = [];

        try {
          final result = await getQuest!(event.gameType, event.level);
          if (result != null && result is List<GrammarQuest>) {
            quests.addAll(result);
          }
        } catch (e) {
          try {
            final result = await getQuest!(event.gameType);
            if (result != null && result is List<GrammarQuest>) {
              quests.addAll(result);
            }
          } catch (_) {}
        }

        if (quests.isEmpty) {
          emit(GrammarError("We couldn't find any quests for this level yet."));
          return;
        }

        if (quests.isEmpty) {
          emit(GrammarError("Check back later for new quests!"));
        } else {
          // ENSURE STICKY 3 QUESTIONS PER LEVEL
          final limitedQuests = quests.take(3).toList();
          emit(
            GrammarLoaded(
              quests: limitedQuests,
              currentIndex: 0,
              livesRemaining: 3, // Standard 3 lives
            ),
          );
        }
      } catch (e) {
        emit(GrammarError("Failed to fetch quests: $e"));
      }
    });

    on<SubmitAnswer>((event, emit) async {
      final currentState = state;
      if (currentState is! GrammarLoaded) return;

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
          GrammarGameOver(
            quests: currentState.quests,
            currentIndex: currentState.currentIndex,
          ),
        );
      }
    });

    on<NextQuestion>((event, emit) async {
      final currentState = state;
      if (currentState is! GrammarLoaded) return;

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

          emit(GrammarGameComplete(xpEarned: totalXp, coinsEarned: totalCoins));

          // PERSISTENCE
          if (currentGameType != null) {
            if (updateUserCoins != null) await updateUserCoins!(totalXp);
            if (updateUserRewards != null) await updateUserRewards!(totalCoins);
            if (updateCategoryStats != null) {
              await updateCategoryStats!(currentGameType!, 100);
            }
            if (updateUnlockedLevel != null && currentLevel != null) {
              await updateUnlockedLevel!(currentGameType!, currentLevel! + 1);
            }
            if (awardBadge != null) await awardBadge!('grammar_master');
          }
        }
      } else {
        // Just clear the overlay if it was wrong but they still have lives
        emit(currentState.copyWith(lastAnswerCorrect: null));
      }
    });

    on<GrammarHintUsed>((event, emit) async {
      if (state is GrammarLoaded) {
        final s = state as GrammarLoaded;
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
      if (state is GrammarGameOver) {
        final s = state as GrammarGameOver;
        emit(
          GrammarLoaded(
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
      // Ideally we would re-fetch, but for now just transition back to initial to trigger UI reload
      emit(GrammarInitial());
    });
  }
}
