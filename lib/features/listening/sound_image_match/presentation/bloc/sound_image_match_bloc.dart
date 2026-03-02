import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/listening/sound_image_match/domain/usecases/get_sound_image_match_quests.dart';
import 'sound_image_match_event.dart';
import 'sound_image_match_state.dart';

class SoundImageMatchBloc extends Bloc<SoundImageMatchEvent, SoundImageMatchState> {
  final GetSoundImageMatchQuests getQuests;

  SoundImageMatchBloc({required this.getQuests}) : super(SoundImageMatchInitial()) {
    on<FetchSoundImageMatchQuests>(_onFetchQuests);
    on<SubmitSoundImageMatchAnswer>(_onSubmitAnswer);
    on<NextSoundImageMatchQuestion>(_onNextQuestion);
    on<RestoreSoundImageMatchLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchSoundImageMatchQuests event,
    Emitter<SoundImageMatchState> emit,
  ) async {
    emit(SoundImageMatchLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(SoundImageMatchError(failure.message)),
      (quests) => emit(SoundImageMatchLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitSoundImageMatchAnswer event,
    Emitter<SoundImageMatchState> emit,
  ) {
    final state = this.state;
    if (state is SoundImageMatchLoaded) {
      if (event.userIndex == event.correctIndex) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(SoundImageMatchGameOver());
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
    NextSoundImageMatchQuestion event,
    Emitter<SoundImageMatchState> emit,
  ) {
    final state = this.state;
    if (state is SoundImageMatchLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(SoundImageMatchGameComplete(
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
    RestoreSoundImageMatchLife event,
    Emitter<SoundImageMatchState> emit,
  ) {
    emit(SoundImageMatchInitial());
  }
}

