import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/game/domain/entities/game_quest.dart';
import 'game_bloc_event_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial()) {
    on<StartGame>(_onStartGame);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<NextLevel>(_onNextLevel);
  }

  void _onStartGame(StartGame event, Emitter<GameState> emit) {
    emit(GameInProgress(currentQuest: _generateQuest(1), level: 1, score: 0));
  }

  void _onSubmitAnswer(SubmitAnswer event, Emitter<GameState> emit) {
    if (state is GameInProgress) {
      final currentState = state as GameInProgress;
      // Logic for checking answer would go here
      // For now, we'll just increment score if it's correct
      emit(
        GameInProgress(
          currentQuest: currentState.currentQuest,
          level: currentState.level,
          score: currentState.score + 10,
        ),
      );
      add(NextLevel());
    }
  }

  void _onNextLevel(NextLevel event, Emitter<GameState> emit) {
    if (state is GameInProgress) {
      final currentState = state as GameInProgress;
      final nextLevel = currentState.level + 1;
      emit(
        GameInProgress(
          currentQuest: _generateQuest(nextLevel),
          level: nextLevel,
          score: currentState.score,
        ),
      );
    }
  }

  GameQuest _generateQuest(int level) {
    // Deterministic mock quest generation for "unlimited" levels
    final questId = 'q_$level';
    if (level % 3 == 1) {
      return ReadingQuest(
        id: questId,
        instruction: 'Read the text and answer the question.',
        difficulty: level,
        passage:
            'Alice was beginning to get very tired of sitting by her sister on the bank...',
        options: ['Sitting', 'Running', 'Sleeping', 'Eating'],
        correctOptionIndex: 0,
      );
    } else if (level % 3 == 2) {
      return WritingQuest(
        id: questId,
        instruction: 'Translate the following to English.',
        difficulty: level,
        prompt: 'Hola, ¿cómo estás?',
        expectedAnswer: 'Hello, how are you?',
      );
    } else {
      return SpeakingQuest(
        id: questId,
        instruction: 'Say the following sentence clearly.',
        difficulty: level,
        textToSpeak: 'The quick brown fox jumps over the lazy dog.',
      );
    }
  }
}
