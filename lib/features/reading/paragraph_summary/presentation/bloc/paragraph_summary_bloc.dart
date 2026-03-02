import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/reading/paragraph_summary/domain/usecases/get_paragraph_summary_quests.dart';
import 'paragraph_summary_event.dart';
import 'paragraph_summary_state.dart';

class ParagraphSummaryBloc extends Bloc<ParagraphSummaryEvent, ParagraphSummaryState> {
  final GetParagraphSummaryQuests getQuests;

  ParagraphSummaryBloc({required this.getQuests}) : super(ParagraphSummaryInitial()) {
    on<FetchParagraphSummaryQuests>(_onFetchQuests);
    on<SubmitParagraphSummaryAnswer>(_onSubmitAnswer);
    on<NextParagraphSummaryQuestion>(_onNextQuestion);
    on<RestoreParagraphSummaryLife>(_onRestoreLife);
    on<ParagraphSummaryHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchParagraphSummaryQuests event,
    Emitter<ParagraphSummaryState> emit,
  ) async {
    emit(ParagraphSummaryLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(ParagraphSummaryError(failure.message)),
      (quests) => emit(ParagraphSummaryLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitParagraphSummaryAnswer event,
    Emitter<ParagraphSummaryState> emit,
  ) {
    final state = this.state;
    if (state is ParagraphSummaryLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(ParagraphSummaryGameOver());
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
    NextParagraphSummaryQuestion event,
    Emitter<ParagraphSummaryState> emit,
  ) {
    final state = this.state;
    if (state is ParagraphSummaryLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(ParagraphSummaryGameComplete(
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
    RestoreParagraphSummaryLife event,
    Emitter<ParagraphSummaryState> emit,
  ) {
    emit(ParagraphSummaryInitial());
  }

  void _onHintUsed(
    ParagraphSummaryHintUsed event,
    Emitter<ParagraphSummaryState> emit,
  ) {
    final state = this.state;
    if (state is ParagraphSummaryLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
