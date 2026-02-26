import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/reading_quest.dart';
import '../../../../core/domain/entities/game_quest.dart';
import '../../../../core/network/network_info.dart';

// --- EVENTS ---
abstract class ReadingEvent {}

class FetchReadingQuests extends ReadingEvent {
  final dynamic gameType;
  final int level;
  FetchReadingQuests({required this.gameType, required this.level});
}

class SubmitAnswer extends ReadingEvent {
  final bool isCorrect;
  SubmitAnswer(this.isCorrect);
}

class NextQuestion extends ReadingEvent {}

class RestartLevel extends ReadingEvent {}

class ReadingHintUsed extends ReadingEvent {}

class RestoreLife extends ReadingEvent {}

class AddHint extends ReadingEvent {}

// --- STATES ---
abstract class ReadingState {}

class ReadingInitial extends ReadingState {}

class ReadingLoading extends ReadingState {}

class ReadingLoaded extends ReadingState {
  final List<ReadingQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  ReadingQuest get currentQuest => quests[currentIndex];

  ReadingLoaded({
    required this.quests,
    required this.currentIndex,
    required this.livesRemaining,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  ReadingLoaded copyWith({
    List<ReadingQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return ReadingLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect, // Nullable override
      hintUsed: hintUsed ?? this.hintUsed,
    );
  }
}

class ReadingError extends ReadingState {
  final String message;
  ReadingError(this.message);
}

class ReadingGameComplete extends ReadingState {
  final int xpEarned;
  final int coinsEarned;
  ReadingGameComplete({required this.xpEarned, required this.coinsEarned});
}

class ReadingGameOver extends ReadingState {
  final List<ReadingQuest> quests;
  final int currentIndex;

  ReadingGameOver({required this.quests, required this.currentIndex});
}

// --- BLOC ---
class ReadingBloc extends Bloc<ReadingEvent, ReadingState> {
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

  ReadingBloc({
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
  }) : super(ReadingInitial()) {
    on<FetchReadingQuests>((event, emit) async {
      currentGameType = event.gameType is GameSubtype
          ? (event.gameType as GameSubtype).name
          : event.gameType.toString();
      currentLevel = event.level;

      emit(ReadingLoading());
      try {
        final isConnected = await networkInfo.isConnected;
        if (!isConnected) {
          emit(
            ReadingError("No internet connection. Please check your network."),
          );
          return;
        }

        if (getQuest == null) {
          emit(ReadingError("UseCase dependency not provided"));
          return;
        }

        final List<ReadingQuest> quests = [];

        try {
          final result = await getQuest!(event.gameType, event.level);
          if (result != null && result is List<ReadingQuest>) {
            quests.addAll(result);
          }
        } catch (e) {
          try {
            final result = await getQuest!(event.gameType);
            if (result != null && result is List<ReadingQuest>) {
              quests.addAll(result);
            }
          } catch (_) {}
        }

        if (quests.isEmpty) {
          emit(ReadingError("We couldn't find any quests for this level yet."));
        } else {
          // ENSURE STICKY 3 QUESTIONS PER LEVEL
          final limitedQuests = quests.take(3).toList();
          emit(
            ReadingLoaded(
              quests: limitedQuests,
              currentIndex: 0,
              livesRemaining: 3, // Standard 3 lives
            ),
          );
        }
      } catch (e) {
        emit(ReadingError("Failed to fetch quests: $e"));
      }
    });

    on<SubmitAnswer>((event, emit) async {
      final currentState = state;
      if (currentState is! ReadingLoaded) return;

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
          ReadingGameOver(
            quests: currentState.quests,
            currentIndex: currentState.currentIndex,
          ),
        );
      }
    });

    on<NextQuestion>((event, emit) async {
      final currentState = state;
      if (currentState is! ReadingLoaded) return;

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

          emit(ReadingGameComplete(xpEarned: totalXp, coinsEarned: totalCoins));

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
            if (awardBadge != null) await awardBadge!('reading_master');
          }
        }
      } else {
        // Just clear the overlay if it was wrong but they still have lives
        emit(currentState.copyWith(lastAnswerCorrect: null));
      }
    });

    on<ReadingHintUsed>((event, emit) async {
      if (state is ReadingLoaded) {
        final s = state as ReadingLoaded;
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
      if (state is ReadingGameOver) {
        final s = state as ReadingGameOver;
        emit(
          ReadingLoaded(
            quests: s.quests,
            currentIndex: s.currentIndex,
            livesRemaining: 1,
            lastAnswerCorrect: null,
            hintUsed: false,
          ),
        );
      }
    });

    on<AddHint>((event, emit) async {});

    on<RestartLevel>((event, emit) {
      emit(ReadingInitial());
    });
  }
}
