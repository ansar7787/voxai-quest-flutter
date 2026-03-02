import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/writing/sentence_builder/domain/usecases/get_sentence_builder_quests.dart';
import 'sentence_builder_event.dart';
import 'sentence_builder_state.dart';

class SentenceBuilderBloc extends Bloc<SentenceBuilderEvent, SentenceBuilderState> {
  final GetSentenceBuilderQuests getQuests;

  SentenceBuilderBloc({required this.getQuests}) : super(SentenceBuilderInitial()) {
    on<FetchSentenceBuilderQuests>(_onFetchQuests);
    on<SubmitSentenceBuilderAnswer>(_onSubmitAnswer);
    on<NextSentenceBuilderQuestion>(_onNextQuestion);
    on<RestoreSentenceBuilderLife>(_onRestoreLife);
    on<SentenceBuilderHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchSentenceBuilderQuests event,
    Emitter<SentenceBuilderState> emit,
  ) async {
    emit(SentenceBuilderLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(SentenceBuilderError(failure.message)),
      (quests) => emit(SentenceBuilderLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitSentenceBuilderAnswer event,
    Emitter<SentenceBuilderState> emit,
  ) {
    final state = this.state;
    if (state is SentenceBuilderLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(SentenceBuilderGameOver());
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
    NextSentenceBuilderQuestion event,
    Emitter<SentenceBuilderState> emit,
  ) {
    final state = this.state;
    if (state is SentenceBuilderLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(SentenceBuilderGameComplete(
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
    RestoreSentenceBuilderLife event,
    Emitter<SentenceBuilderState> emit,
  ) {
    emit(SentenceBuilderInitial());
  }

  void _onHintUsed(
    SentenceBuilderHintUsed event,
    Emitter<SentenceBuilderState> emit,
  ) {
    final state = this.state;
    if (state is SentenceBuilderLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
