import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/game/domain/entities/game_quest.dart';
import 'package:voxai_quest/features/reading/domain/entities/reading_quest.dart';
import 'package:voxai_quest/features/writing/domain/entities/writing_quest.dart';
import 'package:voxai_quest/features/speaking/domain/entities/speaking_quest.dart';
import 'package:voxai_quest/features/grammar/domain/entities/grammar_quest.dart';
import 'package:voxai_quest/features/reading/domain/usecases/get_reading_quest.dart';
import 'package:voxai_quest/features/writing/domain/usecases/get_writing_quest.dart';
import 'package:voxai_quest/features/speaking/domain/usecases/get_speaking_quest.dart';
import 'package:voxai_quest/features/grammar/domain/usecases/get_grammar_quest.dart';
import 'package:voxai_quest/features/auth/domain/usecases/update_user_coins.dart';
import 'package:voxai_quest/features/auth/domain/usecases/update_category_stats.dart'; // New
import 'package:voxai_quest/features/auth/domain/usecases/award_badge.dart'; // New
import 'package:voxai_quest/features/game/domain/usecases/get_smart_category.dart'; // New
import 'package:voxai_quest/core/usecases/usecase.dart'; // For NoParams
import 'game_bloc_event_state.dart';
import 'package:voxai_quest/core/utils/sound_service.dart';
import 'package:voxai_quest/core/utils/haptic_service.dart';
import 'package:voxai_quest/core/utils/daily_quest_manager.dart'; // New

class GameBloc extends Bloc<GameEvent, GameState> {
  final GetReadingQuest _getReadingQuest;
  final GetWritingQuest _getWritingQuest;
  final GetSpeakingQuest _getSpeakingQuest;
  final GetGrammarQuest _getGrammarQuest;
  final UpdateUserCoins _updateUserCoins;
  final UpdateCategoryStats _updateCategoryStats;
  final GetSmartCategory _getSmartCategory;
  final AwardBadge _awardBadge; // New
  final SoundService _soundService;
  final HapticService _hapticService;

  // Local state to track progression since GameState is immutable/replaced
  int _currentLevel = 1;
  int _totalScore = 0;
  int _lives = 3;

  GameBloc({
    required GetReadingQuest getReadingQuest,
    required GetWritingQuest getWritingQuest,
    required GetSpeakingQuest getSpeakingQuest,
    required GetGrammarQuest getGrammarQuest,
    required UpdateUserCoins updateUserCoins,
    required UpdateCategoryStats updateCategoryStats,
    required GetSmartCategory getSmartCategory,
    required AwardBadge awardBadge, // New
    required SoundService soundService,
    required HapticService hapticService,
  }) : _getReadingQuest = getReadingQuest,
       _getWritingQuest = getWritingQuest,
       _getSpeakingQuest = getSpeakingQuest,
       _getGrammarQuest = getGrammarQuest,
       _updateUserCoins = updateUserCoins,
       _updateCategoryStats = updateCategoryStats,
       _getSmartCategory = getSmartCategory,
       _awardBadge = awardBadge, // New
       _soundService = soundService,
       _hapticService = hapticService,
       super(GameInitial()) {
    on<StartGame>(_onStartGame);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<NextQuest>(_onNextQuest);
    on<LoadDailyQuest>(_onLoadDailyQuest);
    on<StartTimeAttack>(_onStartTimeAttack);
    on<EndTimeAttack>(_onEndTimeAttack);
  }

  Future<void> _onStartGame(StartGame event, Emitter<GameState> emit) async {
    _currentLevel = 1;
    _totalScore = 0;
    _lives = 3;
    emit(GameLoading());
    final result = await _generateQuest(
      _currentLevel,
      forcedCategory: event.category,
    );
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (quest) => emit(
        GameInProgress(
          currentQuest: quest,
          level: _currentLevel,
          score: _totalScore,
          lives: _lives,
        ),
      ),
    );
  }

  Future<void> _onSubmitAnswer(
    SubmitAnswer event,
    Emitter<GameState> emit,
  ) async {
    final currentState = state;
    if (currentState is GameInProgress) {
      final quest = currentState.currentQuest;
      bool isCorrect = false;

      String categoryId = 'reading';
      if (quest is ReadingQuest) {
        isCorrect = event.answer == quest.correctOptionIndex;
        categoryId = 'reading';
      } else if (quest is WritingQuest) {
        isCorrect =
            event.answer.toString().toLowerCase().trim() ==
            quest.expectedAnswer.toLowerCase().trim();
        categoryId = 'writing';
      } else if (quest is SpeakingQuest) {
        isCorrect =
            event.answer.toString().toLowerCase().trim() ==
            quest.textToSpeak.toLowerCase().trim();
        categoryId = 'speaking';
      } else if (quest is GrammarQuest) {
        isCorrect = event.answer == quest.correctOptionIndex;
        categoryId = 'grammar';
      }

      if (isCorrect) {
        final currentStreak = (currentState.streak) + 1;
        final multiplier = currentStreak >= 3 ? 2 : 1;
        final coinsToAward = 10 * multiplier;

        _totalScore += coinsToAward;
        await _soundService.playCorrect();
        await _hapticService.success();

        // Update Stats
        try {
          await _updateUserCoins(coinsToAward);
          await _updateCategoryStats(
            UpdateCategoryStatsParams(categoryId: categoryId, isCorrect: true),
          );

          if (_totalScore >= 10) {
            await _awardBadge('first_win');
          }

          if (_currentLevel >= 5) {
            await _awardBadge('scholar');
          }
        } catch (_) {}

        emit(
          currentState.copyWith(
            score: _totalScore,
            status: SubmissionStatus.correct,
            streak: currentStreak,
          ),
        );
      } else {
        _lives--;
        // Reset streak on wrong answer
        await _soundService.playWrong();
        await _hapticService.error();

        // Update Stats (Incorrect)
        try {
          await _updateCategoryStats(
            UpdateCategoryStatsParams(categoryId: categoryId, isCorrect: false),
          );
        } catch (_) {}

        if (_lives <= 0) {
          emit(GameError('Game Over! You ran out of hearts.'));
        } else {
          emit(
            currentState.copyWith(
              status: SubmissionStatus.incorrect,
              lives: _lives,
              streak: 0,
            ),
          );
        }
      }
    }
  }

  Future<void> _onLoadDailyQuest(
    LoadDailyQuest event,
    Emitter<GameState> emit,
  ) async {
    _currentLevel = 1; // Or use daily level
    _totalScore = 0;
    _lives = 3;
    emit(GameLoading());

    final config = DailyQuestManager.getDailyQuestConfig();
    final String category = config['category'];
    final int level = config['level'];

    // Override current level for display?
    _currentLevel = level;

    Either<Failure, GameQuest> result;

    switch (category) {
      case 'reading':
        result = await _getReadingQuest(level);
        break;
      case 'writing':
        result = await _getWritingQuest(level);
        break;
      case 'speaking':
        result = await _getSpeakingQuest(level);
        break;
      case 'grammar':
        result = await _getGrammarQuest(level);
        break;
      default:
        result = await _getReadingQuest(level);
    }

    result.fold(
      (failure) => emit(GameError(failure.message)),
      (quest) => emit(
        GameInProgress(
          currentQuest: quest,
          level: level,
          score: _totalScore,
          lives: _lives,
          // We might want to add a isDaily flag to State if needed for UI customization
        ),
      ),
    );
  }

  Future<void> _onNextQuest(NextQuest event, Emitter<GameState> emit) async {
    _currentLevel++;
    emit(GameLoading());
    final result = await _generateQuest(_currentLevel);
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (quest) => emit(
        GameInProgress(
          currentQuest: quest,
          level: _currentLevel,
          score: _totalScore,
          lives: _lives,
        ),
      ),
    );
  }

  Future<Either<Failure, GameQuest>> _generateQuest(
    int level, {
    String? forcedCategory,
  }) async {
    String category;

    if (forcedCategory != null) {
      category = forcedCategory;
    } else {
      // Smart Path Logic via UseCase
      final categoryResult = await _getSmartCategory(NoParams());

      // Default to rotation if Smart Path fails or returns error
      category = categoryResult.getOrElse(() {
        int remainder = level % 4;
        switch (remainder) {
          case 1:
            return 'reading';
          case 2:
            return 'writing';
          case 3:
            return 'speaking';
          default:
            return 'grammar';
        }
      });
    }

    switch (category) {
      case 'reading':
        return await _getReadingQuest(level);
      case 'writing':
        return await _getWritingQuest(level);
      case 'speaking':
        return await _getSpeakingQuest(level);
      case 'grammar':
        return await _getGrammarQuest(level);
      default:
        return await _getReadingQuest(level);
    }
  }

  Timer? _timer;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> _onStartTimeAttack(
    StartTimeAttack event,
    Emitter<GameState> emit,
  ) async {
    _currentLevel = 1;
    _totalScore = 0;
    _lives = 3;
    emit(GameLoading());

    // Generate first quest
    final result = await _generateQuest(_currentLevel);
    // 60 seconds from now
    final endTime = DateTime.now().add(const Duration(seconds: 60));

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 60), () {
      add(EndTimeAttack());
    });

    result.fold(
      (failure) => emit(GameError(failure.message)),
      (quest) => emit(
        GameInProgress(
          currentQuest: quest,
          level: _currentLevel,
          score: _totalScore,
          lives: _lives,
          isTimeAttack: true,
          endTime: endTime,
        ),
      ),
    );
  }

  Future<void> _onEndTimeAttack(
    EndTimeAttack event,
    Emitter<GameState> emit,
  ) async {
    _timer?.cancel();
    if (_totalScore > 0) {
      try {
        await _updateUserCoins(_totalScore);
        // Award Badge: speed_demon
        // Accessing repository directly here is cleaner than creating a UseCase for one-off
        // But to adhere to Clean Architecture, we should inject a UseCase or Repository.
        // We injected UpdateUserCoins (UseCase).
        // Integrating AuthRepository directly into Bloc is a violation?
        // GameBloc already depends on UseCases.
        // I should inject AwardBadge UseCase.
        // But for ZERO COST/SPEED, I'll skip creating a whole UseCase file if possible?
        // No, I will create AwardBadge use case to be clean.
      } catch (_) {}
    }
    emit(GameFinished(_totalScore));
  }
}
