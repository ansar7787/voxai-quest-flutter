import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/writing/complete_sentence/domain/usecases/get_complete_sentence_quests.dart';
import 'complete_sentence_event.dart';
import 'complete_sentence_state.dart';

class CompleteSentenceBloc extends Bloc<CompleteSentenceEvent, CompleteSentenceState> {
  final GetCompleteSentenceQuests getQuests;

  CompleteSentenceBloc({required this.getQuests}) : super(CompleteSentenceInitial()) {
    on<FetchCompleteSentenceQuests>(_onFetchQuests);
    on<SubmitCompleteSentenceAnswer>(_onSubmitAnswer);
    on<NextCompleteSentenceQuestion>(_onNextQuestion);
    on<RestoreCompleteSentenceLife>(_onRestoreLife);
    on<CompleteSentenceHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchCompleteSentenceQuests event,
    Emitter<CompleteSentenceState> emit,
  ) async {
    emit(CompleteSentenceLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(CompleteSentenceError(failure.message)),
      (quests) => emit(CompleteSentenceLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitCompleteSentenceAnswer event,
    Emitter<CompleteSentenceState> emit,
  ) {
    final state = this.state;
    if (state is CompleteSentenceLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(CompleteSentenceGameOver());
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
    NextCompleteSentenceQuestion event,
    Emitter<CompleteSentenceState> emit,
  ) {
    final state = this.state;
    if (state is CompleteSentenceLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(CompleteSentenceGameComplete(
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
    RestoreCompleteSentenceLife event,
    Emitter<CompleteSentenceState> emit,
  ) {
    emit(CompleteSentenceInitial());
  }

  void _onHintUsed(
    CompleteSentenceHintUsed event,
    Emitter<CompleteSentenceState> emit,
  ) {
    final state = this.state;
    if (state is CompleteSentenceLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
