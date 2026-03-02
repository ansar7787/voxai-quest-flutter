import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:voxai_quest/features/listening/audio_sentence_order/domain/usecases/get_audio_sentence_order_quests.dart';
import 'audio_sentence_order_event.dart';
import 'audio_sentence_order_state.dart';

class AudioSentenceOrderBloc extends Bloc<AudioSentenceOrderEvent, AudioSentenceOrderState> {
  final GetAudioSentenceOrderQuests getQuests;

  AudioSentenceOrderBloc({required this.getQuests}) : super(AudioSentenceOrderInitial()) {
    on<FetchAudioSentenceOrderQuests>(_onFetchQuests);
    on<SubmitAudioSentenceOrderAnswer>(_onSubmitAnswer);
    on<NextAudioSentenceOrderQuestion>(_onNextQuestion);
    on<RestoreAudioSentenceOrderLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchAudioSentenceOrderQuests event,
    Emitter<AudioSentenceOrderState> emit,
  ) async {
    emit(AudioSentenceOrderLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(AudioSentenceOrderError(failure.message)),
      (quests) => emit(AudioSentenceOrderLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitAudioSentenceOrderAnswer event,
    Emitter<AudioSentenceOrderState> emit,
  ) {
    final state = this.state;
    if (state is AudioSentenceOrderLoaded) {
      final isCorrect = const ListEquality().equals(event.userOrder, event.correctOrder);
      if (isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(AudioSentenceOrderGameOver());
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
    NextAudioSentenceOrderQuestion event,
    Emitter<AudioSentenceOrderState> emit,
  ) {
    final state = this.state;
    if (state is AudioSentenceOrderLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(AudioSentenceOrderGameComplete(
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
    RestoreAudioSentenceOrderLife event,
    Emitter<AudioSentenceOrderState> emit,
  ) {
    emit(AudioSentenceOrderInitial());
  }
}

