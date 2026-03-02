import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/vocabulary/word_formation/domain/usecases/get_word_formation_quests.dart';
import 'word_formation_event.dart';
import 'word_formation_state.dart';

class WordFormationBloc extends Bloc<WordFormationEvent, WordFormationState> {
  final GetWordFormationQuests getQuests;

  WordFormationBloc({required this.getQuests}) : super(WordFormationInitial()) {
    on<FetchWordFormationQuests>(_onFetchQuests);
    on<SubmitWordFormationAnswer>(_onSubmitAnswer);
    on<NextWordFormationQuestion>(_onNextQuestion);
    on<RestoreWordFormationLife>(_onRestoreLife);
    on<WordFormationHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchWordFormationQuests event,
    Emitter<WordFormationState> emit,
  ) async {
    emit(WordFormationLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(WordFormationError(failure.message)),
      (quests) {
        if (quests.isEmpty) {
          emit(const WordFormationError("No quests found for this level."));
        } else {
          emit(WordFormationLoaded(quests: quests));
        }
      },
    );
  }

  void _onSubmitAnswer(
    SubmitWordFormationAnswer event,
    Emitter<WordFormationState> emit,
  ) {
    final state = this.state;
    if (state is WordFormationLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(WordFormationGameOver());
        } else {
          emit(state.copyWith(
            livesRemaining: newLives,
            lastAnswerCorrect: false,
          ));
        }
      }
    }
  }

  void _onNextQuestion(
    NextWordFormationQuestion event,
    Emitter<WordFormationState> emit,
  ) {
    final state = this.state;
    if (state is WordFormationLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(WordFormationGameComplete(
          xpEarned: totalQuests * 10,
          coinsEarned: totalQuests * 5,
        ));
      } else {
        emit(state.copyWith(
          currentIndex: nextIndex,
          lastAnswerCorrect: null,
          hintUsed: false,
        ));
      }
    }
  }

  void _onRestoreLife(
    RestoreWordFormationLife event,
    Emitter<WordFormationState> emit,
  ) {
    emit(WordFormationInitial());
  }

  void _onHintUsed(
    WordFormationHintUsed event,
    Emitter<WordFormationState> emit,
  ) {
    final state = this.state;
    if (state is WordFormationLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
