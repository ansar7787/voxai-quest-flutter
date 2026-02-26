import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/domain/usecases/update_user_rewards.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import '../../domain/entities/vocabulary_quest.dart';
import '../../domain/usecases/get_vocabulary_quests.dart';
import '../../../../core/domain/entities/game_quest.dart';

// --- EVENTS ---
abstract class VocabularyEvent {}

class FetchVocabularyQuests extends VocabularyEvent {
  final GameSubtype gameType;
  final int level;
  FetchVocabularyQuests({required this.gameType, required this.level});
}

class SubmitAnswer extends VocabularyEvent {
  final bool isCorrect;
  SubmitAnswer(this.isCorrect);
}

class NextQuestion extends VocabularyEvent {}

class RestartLevel extends VocabularyEvent {}

class VocabularyHintUsed extends VocabularyEvent {}

class RestoreLife extends VocabularyEvent {}

class AddHint extends VocabularyEvent {
  final int count;
  AddHint(this.count);
}

// --- STATES ---
abstract class VocabularyState {}

class VocabularyInitial extends VocabularyState {}

class VocabularyLoading extends VocabularyState {}

class VocabularyLoaded extends VocabularyState {
  final List<VocabularyQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  VocabularyQuest get currentQuest => quests[currentIndex];

  VocabularyLoaded({
    required this.quests,
    required this.currentIndex,
    required this.livesRemaining,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  VocabularyLoaded copyWith({
    List<VocabularyQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return VocabularyLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      hintUsed: hintUsed ?? this.hintUsed,
    );
  }
}

class VocabularyError extends VocabularyState {
  final String message;
  VocabularyError(this.message);
}

class VocabularyGameComplete extends VocabularyState {
  final int xpEarned;
  final int coinsEarned;
  VocabularyGameComplete({required this.xpEarned, required this.coinsEarned});
}

class VocabularyGameOver extends VocabularyState {
  final List<VocabularyQuest> quests;
  final int currentIndex;
  VocabularyGameOver({required this.quests, required this.currentIndex});
}

// --- BLOC ---
class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  final GetVocabularyQuests getQuests;
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

  VocabularyBloc({
    required this.getQuests,
    required this.updateUserCoins,
    required this.updateUserRewards,
    required this.updateCategoryStats,
    required this.updateUnlockedLevel,
    required this.awardBadge,
    required this.soundService,
    required this.hapticService,
    required this.useHint,
    required this.networkInfo,
  }) : super(VocabularyInitial()) {
    on<FetchVocabularyQuests>(_onFetchQuests);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<NextQuestion>(_onNextQuestion);
    on<RestartLevel>(_onRestartLevel);
    on<VocabularyHintUsed>(_onUseHint);
    on<RestoreLife>(_onRestoreLife);
    on<AddHint>(_onAddHint);
  }

  Future<void> _onFetchQuests(
    FetchVocabularyQuests event,
    Emitter<VocabularyState> emit,
  ) async {
    currentGameType = event.gameType.name;
    currentLevel = event.level;

    emit(VocabularyLoading());
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        emit(
          VocabularyError("No internet connection. Please check your network."),
        );
        return;
      }

      final quests = await getQuests(event.gameType.name, event.level);

      if (quests.isEmpty) {
        emit(
          VocabularyError("We couldn't find any quests for this level yet."),
        );
      } else {
        // ENSURE STICKY 3 QUESTIONS PER LEVEL
        final limitedQuests = quests.take(3).toList();
        emit(
          VocabularyLoaded(
            quests: limitedQuests,
            currentIndex: 0,
            livesRemaining: 3, // Standard 3 lives
          ),
        );
      }
    } catch (e) {
      emit(VocabularyError("Failed to fetch quests: $e"));
    }
  }

  Future<void> _onSubmitAnswer(
    SubmitAnswer event,
    Emitter<VocabularyState> emit,
  ) async {
    if (state is VocabularyLoaded) {
      final s = state as VocabularyLoaded;

      if (event.isCorrect) {
        if (soundService != null) await soundService.playCorrect();
        if (hapticService != null) await hapticService.success();
        emit(s.copyWith(lastAnswerCorrect: true));
      } else {
        if (soundService != null) await soundService.playWrong();
        if (hapticService != null) await hapticService.error();
        final newLives = s.livesRemaining - 1;
        if (newLives <= 0) {
          emit(
            VocabularyGameOver(quests: s.quests, currentIndex: s.currentIndex),
          );
        } else {
          emit(s.copyWith(livesRemaining: newLives, lastAnswerCorrect: false));
        }
      }
    }
  }

  Future<void> _onNextQuestion(
    NextQuestion event,
    Emitter<VocabularyState> emit,
  ) async {
    if (state is VocabularyLoaded) {
      final s = state as VocabularyLoaded;
      if (s.currentIndex >= s.quests.length - 1) {
        if (soundService != null) await soundService.playLevelComplete();
        final totalXp = 30; // Standard XP
        final totalCoins = 15; // Standard Coins
        emit(
          VocabularyGameComplete(xpEarned: totalXp, coinsEarned: totalCoins),
        );

        // PERSISTENCE
        if (currentGameType != null && currentLevel != null) {
          if (updateUserRewards != null) {
            await updateUserRewards(
              UpdateUserRewardsParams(
                gameType: currentGameType!,
                level: currentLevel!,
                xpIncrease: 10,
                coinIncrease: 10,
              ),
            );
          }
          if (updateCategoryStats != null) {
            await updateCategoryStats(currentGameType!, true);
          }
          if (awardBadge != null) await awardBadge('vocabulary_master');
        }
      } else {
        emit(
          s.copyWith(
            currentIndex: s.currentIndex + 1,
            lastAnswerCorrect: null,
            hintUsed: false,
          ),
        );
      }
    }
  }

  void _onRestartLevel(RestartLevel event, Emitter<VocabularyState> emit) {
    emit(VocabularyInitial());
  }

  Future<void> _onUseHint(
    VocabularyHintUsed event,
    Emitter<VocabularyState> emit,
  ) async {
    if (state is VocabularyLoaded) {
      final s = state as VocabularyLoaded;
      if (s.hintUsed) return;

      final success = await useHint();
      if (success) {
        emit(s.copyWith(hintUsed: true));
        if (hapticService != null) hapticService.selection();
      }
    }
  }

  void _onRestoreLife(RestoreLife event, Emitter<VocabularyState> emit) {
    if (state is VocabularyGameOver) {
      final s = state as VocabularyGameOver;
      emit(
        VocabularyLoaded(
          quests: s.quests,
          currentIndex: s.currentIndex,
          livesRemaining: 1, // Revive gives 1 life
          lastAnswerCorrect: null,
          hintUsed: false,
        ),
      );
    }
  }

  void _onAddHint(AddHint event, Emitter<VocabularyState> emit) {}
}
