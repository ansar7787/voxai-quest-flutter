import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/speaking/repeat_sentence/domain/usecases/get_repeat_sentence_quests.dart';
import 'repeat_sentence_event.dart';
import 'repeat_sentence_state.dart';

class RepeatSentenceBloc extends Bloc<RepeatSentenceEvent, RepeatSentenceState> {
  final GetRepeatSentenceQuests getQuests;

  RepeatSentenceBloc({required this.getQuests}) : super(RepeatSentenceInitial()) {
    on<FetchRepeatSentenceQuests>(_onFetchQuests);
    on<SubmitRepeatSentenceAnswer>(_onSubmitAnswer);
    on<NextRepeatSentenceQuestion>(_onNextQuestion);
    on<RestoreRepeatSentenceLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchRepeatSentenceQuests event,
    Emitter<RepeatSentenceState> emit,
  ) async {
    emit(RepeatSentenceLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(RepeatSentenceError(failure.message)),
      (quests) => emit(RepeatSentenceLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitRepeatSentenceAnswer event,
    Emitter<RepeatSentenceState> emit,
  ) {
    final state = this.state;
    if (state is RepeatSentenceLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(RepeatSentenceGameOver());
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
    NextRepeatSentenceQuestion event,
    Emitter<RepeatSentenceState> emit,
  ) {
    final state = this.state;
    if (state is RepeatSentenceLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(RepeatSentenceGameComplete(
          xpEarned: totalQuests * 10,
          coinsEarned: totalQuests * 5,
        ));
      } else {
        emit(state.copyWith(
          currentIndex: nextIndex,
          lastAnswerCorrect: null,
        ));
      }
    }
  }

  void _onRestoreLife(
    RestoreRepeatSentenceLife event,
    Emitter<RepeatSentenceState> emit,
  ) {
    emit(RepeatSentenceInitial());
  }
}
