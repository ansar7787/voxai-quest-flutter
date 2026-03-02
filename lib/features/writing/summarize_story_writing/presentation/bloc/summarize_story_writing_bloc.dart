import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/writing/summarize_story_writing/domain/usecases/get_summarize_story_writing_quests.dart';
import 'summarize_story_writing_event.dart';
import 'summarize_story_writing_state.dart';

class SummarizeStoryWritingBloc extends Bloc<SummarizeStoryWritingEvent, SummarizeStoryWritingState> {
  final GetSummarizeStoryWritingQuests getQuests;

  SummarizeStoryWritingBloc({required this.getQuests}) : super(SummarizeStoryWritingInitial()) {
    on<FetchSummarizeStoryWritingQuests>(_onFetchQuests);
    on<SubmitSummarizeStoryWritingAnswer>(_onSubmitAnswer);
    on<NextSummarizeStoryWritingQuestion>(_onNextQuestion);
    on<RestoreSummarizeStoryWritingLife>(_onRestoreLife);
    on<SummarizeStoryWritingHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchSummarizeStoryWritingQuests event,
    Emitter<SummarizeStoryWritingState> emit,
  ) async {
    emit(SummarizeStoryWritingLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(SummarizeStoryWritingError(failure.message)),
      (quests) => emit(SummarizeStoryWritingLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitSummarizeStoryWritingAnswer event,
    Emitter<SummarizeStoryWritingState> emit,
  ) {
    final state = this.state;
    if (state is SummarizeStoryWritingLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(SummarizeStoryWritingGameOver());
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
    NextSummarizeStoryWritingQuestion event,
    Emitter<SummarizeStoryWritingState> emit,
  ) {
    final state = this.state;
    if (state is SummarizeStoryWritingLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(SummarizeStoryWritingGameComplete(
          xpEarned: totalQuests * 15,
          coinsEarned: totalQuests * 8,
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
    RestoreSummarizeStoryWritingLife event,
    Emitter<SummarizeStoryWritingState> emit,
  ) {
    emit(SummarizeStoryWritingInitial());
  }

  void _onHintUsed(
    SummarizeStoryWritingHintUsed event,
    Emitter<SummarizeStoryWritingState> emit,
  ) {
    final state = this.state;
    if (state is SummarizeStoryWritingLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
