import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/speaking/speak_missing_word/domain/usecases/get_speak_missing_word_quests.dart';
import 'speak_missing_word_event.dart';
import 'speak_missing_word_state.dart';

class SpeakMissingWordBloc extends Bloc<SpeakMissingWordEvent, SpeakMissingWordState> {
  final GetSpeakMissingWordQuests getQuests;

  SpeakMissingWordBloc({required this.getQuests}) : super(SpeakMissingWordInitial()) {
    on<FetchSpeakMissingWordQuests>(_onFetchQuests);
    on<SubmitSpeakMissingWordAnswer>(_onSubmitAnswer);
    on<NextSpeakMissingWordQuestion>(_onNextQuestion);
    on<RestoreSpeakMissingWordLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchSpeakMissingWordQuests event,
    Emitter<SpeakMissingWordState> emit,
  ) async {
    emit(SpeakMissingWordLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(SpeakMissingWordError(failure.message)),
      (quests) => emit(SpeakMissingWordLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitSpeakMissingWordAnswer event,
    Emitter<SpeakMissingWordState> emit,
  ) {
    final state = this.state;
    if (state is SpeakMissingWordLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(SpeakMissingWordGameOver());
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
    NextSpeakMissingWordQuestion event,
    Emitter<SpeakMissingWordState> emit,
  ) {
    final state = this.state;
    if (state is SpeakMissingWordLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(SpeakMissingWordGameComplete(
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
    RestoreSpeakMissingWordLife event,
    Emitter<SpeakMissingWordState> emit,
  ) {
    emit(SpeakMissingWordInitial());
  }
}
