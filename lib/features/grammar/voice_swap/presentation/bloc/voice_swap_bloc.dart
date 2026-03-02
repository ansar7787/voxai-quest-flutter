import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/grammar/voice_swap/domain/usecases/get_voice_swap_quests.dart';
import 'voice_swap_event.dart';
import 'voice_swap_state.dart';

class VoiceSwapBloc extends Bloc<VoiceSwapEvent, VoiceSwapState> {
  final GetVoiceSwapQuests getQuests;

  VoiceSwapBloc({required this.getQuests}) : super(VoiceSwapInitial()) {
    on<FetchVoiceSwapQuests>(_onFetchQuests);
    on<SubmitVoiceSwapAnswer>(_onSubmitAnswer);
    on<NextVoiceSwapQuestion>(_onNextQuestion);
    on<RestoreVoiceSwapLife>(_onRestoreLife);
    on<VoiceSwapHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchVoiceSwapQuests event,
    Emitter<VoiceSwapState> emit,
  ) async {
    emit(VoiceSwapLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(VoiceSwapError(failure.message)),
      (quests) => emit(VoiceSwapLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitVoiceSwapAnswer event,
    Emitter<VoiceSwapState> emit,
  ) {
    final state = this.state;
    if (state is VoiceSwapLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(VoiceSwapGameOver());
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
    NextVoiceSwapQuestion event,
    Emitter<VoiceSwapState> emit,
  ) {
    final state = this.state;
    if (state is VoiceSwapLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(VoiceSwapGameComplete(
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
    RestoreVoiceSwapLife event,
    Emitter<VoiceSwapState> emit,
  ) {
    emit(VoiceSwapInitial());
  }

  void _onHintUsed(
    VoiceSwapHintUsed event,
    Emitter<VoiceSwapState> emit,
  ) {
    final state = this.state;
    if (state is VoiceSwapLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
