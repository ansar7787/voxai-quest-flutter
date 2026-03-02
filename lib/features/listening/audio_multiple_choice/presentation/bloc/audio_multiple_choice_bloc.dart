import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/listening/audio_multiple_choice/domain/usecases/get_audio_multiple_choice_quests.dart';
import 'audio_multiple_choice_event.dart';
import 'audio_multiple_choice_state.dart';

class AudioMultipleChoiceBloc
    extends Bloc<AudioMultipleChoiceEvent, AudioMultipleChoiceState> {
  final GetAudioMultipleChoiceQuests getQuests;

  AudioMultipleChoiceBloc({required this.getQuests})
    : super(AudioMultipleChoiceInitial()) {
    on<FetchAudioMultipleChoiceQuests>(_onFetchQuests);
    on<SubmitAudioMultipleChoiceAnswer>(_onSubmitAnswer);
    on<NextAudioMultipleChoiceQuestion>(_onNextQuestion);
    on<RestoreAudioMultipleChoiceLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchAudioMultipleChoiceQuests event,
    Emitter<AudioMultipleChoiceState> emit,
  ) async {
    emit(AudioMultipleChoiceLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(AudioMultipleChoiceError(failure.message)),
      (quests) => emit(AudioMultipleChoiceLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitAudioMultipleChoiceAnswer event,
    Emitter<AudioMultipleChoiceState> emit,
  ) {
    final state = this.state;
    if (state is AudioMultipleChoiceLoaded) {
      if (event.selectedIndex == event.correctIndex) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(AudioMultipleChoiceGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextAudioMultipleChoiceQuestion event,
    Emitter<AudioMultipleChoiceState> emit,
  ) {
    final state = this.state;
    if (state is AudioMultipleChoiceLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          AudioMultipleChoiceGameComplete(
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
    RestoreAudioMultipleChoiceLife event,
    Emitter<AudioMultipleChoiceState> emit,
  ) {
    emit(AudioMultipleChoiceInitial());
  }
}
