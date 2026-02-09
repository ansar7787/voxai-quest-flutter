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
import 'game_bloc_event_state.dart';
import 'package:voxai_quest/core/utils/sound_service.dart';
import 'package:voxai_quest/core/utils/haptic_service.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GetReadingQuest _getReadingQuest;
  final GetWritingQuest _getWritingQuest;
  final GetSpeakingQuest _getSpeakingQuest;
  final GetGrammarQuest _getGrammarQuest;
  final UpdateUserCoins _updateUserCoins;
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
    required SoundService soundService,
    required HapticService hapticService,
  }) : _getReadingQuest = getReadingQuest,
       _getWritingQuest = getWritingQuest,
       _getSpeakingQuest = getSpeakingQuest,
       _getGrammarQuest = getGrammarQuest,
       _updateUserCoins = updateUserCoins,
       _soundService = soundService,
       _hapticService = hapticService,
       super(GameInitial()) {
    on<StartGame>(_onStartGame);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<NextQuest>(_onNextQuest);
  }

  Future<void> _onStartGame(StartGame event, Emitter<GameState> emit) async {
    _currentLevel = 1;
    _totalScore = 0;
    _lives = 3;
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

  Future<void> _onSubmitAnswer(
    SubmitAnswer event,
    Emitter<GameState> emit,
  ) async {
    final currentState = state;
    if (currentState is GameInProgress) {
      final quest = currentState.currentQuest;
      bool isCorrect = false;

      if (quest is ReadingQuest) {
        isCorrect = event.answer == quest.correctOptionIndex;
      } else if (quest is WritingQuest) {
        isCorrect =
            event.answer.toString().toLowerCase().trim() ==
            quest.expectedAnswer.toLowerCase().trim();
      } else if (quest is SpeakingQuest) {
        isCorrect =
            event.answer.toString().toLowerCase().trim() ==
            quest.textToSpeak.toLowerCase().trim();
      } else if (quest is GrammarQuest) {
        isCorrect = event.answer == quest.correctOptionIndex;
      }

      if (isCorrect) {
        _totalScore += 10;
        await _soundService.playCorrect();
        await _hapticService.success();
        try {
          await _updateUserCoins(10);
        } catch (_) {}

        emit(
          currentState.copyWith(
            score: _totalScore,
            status: SubmissionStatus.correct,
          ),
        );
      } else {
        _lives--;
        await _soundService.playWrong();
        await _hapticService.error();

        if (_lives <= 0) {
          emit(GameError('Game Over! You ran out of hearts.'));
        } else {
          emit(
            currentState.copyWith(
              status: SubmissionStatus.incorrect,
              lives: _lives,
            ),
          );
        }
      }
    }
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

  Future<Either<Failure, GameQuest>> _generateQuest(int level) async {
    // Rotation: Reading -> Writing -> Speaking -> Grammar
    if (level % 4 == 1) {
      return await _getReadingQuest(level);
    } else if (level % 4 == 2) {
      return await _getWritingQuest(level);
    } else if (level % 4 == 3) {
      return await _getSpeakingQuest(level);
    } else {
      return await _getGrammarQuest(level);
    }
  }
}
