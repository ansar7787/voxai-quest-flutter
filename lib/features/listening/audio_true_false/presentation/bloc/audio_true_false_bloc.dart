import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/listening/audio_true_false/domain/usecases/get_audio_true_false_quests.dart';
import 'audio_true_false_event.dart';
import 'audio_true_false_state.dart';

class AudioTrueFalseBloc
    extends Bloc<AudioTrueFalseEvent, AudioTrueFalseState> {
  final GetAudioTrueFalseQuests getQuests;

  AudioTrueFalseBloc({required this.getQuests})
    : super(AudioTrueFalseInitial()) {
    on<FetchAudioTrueFalseQuests>(_onFetchQuests);
    on<SubmitAudioTrueFalseAnswer>(_onSubmitAnswer);
    on<NextAudioTrueFalseQuestion>(_onNextQuestion);
    on<RestoreAudioTrueFalseLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchAudioTrueFalseQuests event,
    Emitter<AudioTrueFalseState> emit,
  ) async {
    emit(AudioTrueFalseLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(AudioTrueFalseError(failure.message)),
      (quests) => emit(AudioTrueFalseLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitAudioTrueFalseAnswer event,
    Emitter<AudioTrueFalseState> emit,
  ) {
    final state = this.state;
    if (state is AudioTrueFalseLoaded) {
      if (event.userAnswer == event.correctAnswer) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(AudioTrueFalseGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextAudioTrueFalseQuestion event,
    Emitter<AudioTrueFalseState> emit,
  ) {
    final state = this.state;
    if (state is AudioTrueFalseLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          AudioTrueFalseGameComplete(
            xpEarned: totalQuests * 10,
            coinsEarned: totalQuests * 5,
          ),
        );
      } else {
        emit(state.copyWith(currentIndex: nextIndex, lastAnswerCorrect: null));
      }
    }
  }

  void _onRestoreLife(
    RestoreAudioTrueFalseLife event,
    Emitter<AudioTrueFalseState> emit,
  ) {
    emit(AudioTrueFalseInitial());
  }
}
