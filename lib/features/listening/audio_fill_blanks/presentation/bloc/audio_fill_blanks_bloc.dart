import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/listening/audio_fill_blanks/domain/usecases/get_audio_fill_blanks_quests.dart';
import 'audio_fill_blanks_event.dart';
import 'audio_fill_blanks_state.dart';

class AudioFillBlanksBloc
    extends Bloc<AudioFillBlanksEvent, AudioFillBlanksState> {
  final GetAudioFillBlanksQuests getQuests;

  AudioFillBlanksBloc({required this.getQuests})
    : super(AudioFillBlanksInitial()) {
    on<FetchAudioFillBlanksQuests>(_onFetchQuests);
    on<SubmitAudioFillBlanksAnswer>(_onSubmitAnswer);
    on<NextAudioFillBlanksQuestion>(_onNextQuestion);
    on<RestoreAudioFillBlanksLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchAudioFillBlanksQuests event,
    Emitter<AudioFillBlanksState> emit,
  ) async {
    emit(AudioFillBlanksLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(AudioFillBlanksError(failure.message)),
      (quests) => emit(AudioFillBlanksLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitAudioFillBlanksAnswer event,
    Emitter<AudioFillBlanksState> emit,
  ) {
    final state = this.state;
    if (state is AudioFillBlanksLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(AudioFillBlanksGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextAudioFillBlanksQuestion event,
    Emitter<AudioFillBlanksState> emit,
  ) {
    final state = this.state;
    if (state is AudioFillBlanksLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        // Game Complete
        final totalQuests = state.quests.length;
        emit(
          AudioFillBlanksGameComplete(
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
    RestoreAudioFillBlanksLife event,
    Emitter<AudioFillBlanksState> emit,
  ) {
    // Usually triggered on retry, often we'd reload or just reset lives
    // For now, let's assume it restores 1 life and keeps previous progress
    // But usually retry means fresh start
    emit(AudioFillBlanksInitial());
  }
}
