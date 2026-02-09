import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/game/domain/entities/game_quest.dart';
import 'package:voxai_quest/features/reading/domain/entities/reading_quest.dart';
import 'package:voxai_quest/features/writing/domain/entities/writing_quest.dart';
import 'package:voxai_quest/features/speaking/domain/entities/speaking_quest.dart';
import 'package:voxai_quest/features/reading/domain/repositories/reading_repository.dart';
import 'package:voxai_quest/features/writing/domain/repositories/writing_repository.dart';
import 'package:voxai_quest/features/speaking/domain/repositories/speaking_repository.dart';
import 'game_bloc_event_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final ReadingRepository _readingRepository;
  final WritingRepository _writingRepository;
  final SpeakingRepository _speakingRepository;

  GameBloc({
    required ReadingRepository readingRepository,
    required WritingRepository writingRepository,
    required SpeakingRepository speakingRepository,
  }) : _readingRepository = readingRepository,
       _writingRepository = writingRepository,
       _speakingRepository = speakingRepository,
       super(GameInitial()) {
    on<StartGame>(_onStartGame);
    on<SubmitAnswer>(_onSubmitAnswer);
    on<NextQuest>(_onNextQuest);
  }

  Future<void> _onStartGame(StartGame event, Emitter<GameState> emit) async {
    emit(GameLoading());
    final result = await _generateQuest(1);
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (quest) => emit(GameInProgress(currentQuest: quest, level: 1, score: 0)),
    );
  }

  void _onSubmitAnswer(SubmitAnswer event, Emitter<GameState> emit) {
    if (state is GameInProgress) {
      final currentState = state as GameInProgress;
      // In a real app, validate answer here
      final isCorrect = true;
      final newScore = isCorrect ? currentState.score + 10 : currentState.score;

      if (currentState.level >= 50) {
        // Keep it going for now
        emit(GameFinished(newScore));
      } else {
        add(NextQuest());
        emit(currentState.copyWith(score: newScore));
      }
    }
  }

  Future<void> _onNextQuest(NextQuest event, Emitter<GameState> emit) async {
    if (state is GameInProgress) {
      final currentState = state as GameInProgress;
      final nextLevel = currentState.level + 1;
      emit(GameLoading());
      final result = await _generateQuest(nextLevel);
      result.fold(
        (failure) => emit(GameError(failure.message)),
        (quest) =>
            emit(currentState.copyWith(currentQuest: quest, level: nextLevel)),
      );
    }
  }

  Future<Either<Failure, GameQuest>> _generateQuest(int level) async {
    if (level % 3 == 1) {
      return await _readingRepository.getReadingQuest(level);
    } else if (level % 3 == 2) {
      return await _writingRepository.getWritingQuest(level);
    } else {
      return await _speakingRepository.getSpeakingQuest(level);
    }
  }
}
