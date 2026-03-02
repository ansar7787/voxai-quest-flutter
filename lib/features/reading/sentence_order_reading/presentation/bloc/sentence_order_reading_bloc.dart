import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/reading/sentence_order_reading/domain/usecases/get_sentence_order_reading_quests.dart';
import 'sentence_order_reading_event.dart';
import 'sentence_order_reading_state.dart';

class SentenceOrderReadingBloc extends Bloc<SentenceOrderReadingEvent, SentenceOrderReadingState> {
  final GetSentenceOrderReadingQuests getQuests;

  SentenceOrderReadingBloc({required this.getQuests}) : super(SentenceOrderReadingInitial()) {
    on<FetchSentenceOrderReadingQuests>(_onFetchQuests);
    on<SubmitSentenceOrderReadingAnswer>(_onSubmitAnswer);
    on<NextSentenceOrderReadingQuestion>(_onNextQuestion);
    on<RestoreSentenceOrderReadingLife>(_onRestoreLife);
    on<SentenceOrderReadingHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchSentenceOrderReadingQuests event,
    Emitter<SentenceOrderReadingState> emit,
  ) async {
    emit(SentenceOrderReadingLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(SentenceOrderReadingError(failure.message)),
      (quests) => emit(SentenceOrderReadingLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitSentenceOrderReadingAnswer event,
    Emitter<SentenceOrderReadingState> emit,
  ) {
    final state = this.state;
    if (state is SentenceOrderReadingLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(SentenceOrderReadingGameOver());
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
    NextSentenceOrderReadingQuestion event,
    Emitter<SentenceOrderReadingState> emit,
  ) {
    final state = this.state;
    if (state is SentenceOrderReadingLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(SentenceOrderReadingGameComplete(
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
    RestoreSentenceOrderReadingLife event,
    Emitter<SentenceOrderReadingState> emit,
  ) {
    emit(SentenceOrderReadingInitial());
  }

  void _onHintUsed(
    SentenceOrderReadingHintUsed event,
    Emitter<SentenceOrderReadingState> emit,
  ) {
    final state = this.state;
    if (state is SentenceOrderReadingLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
