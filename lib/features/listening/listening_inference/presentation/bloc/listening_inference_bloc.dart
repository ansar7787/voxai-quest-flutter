import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/listening/listening_inference/domain/usecases/get_listening_inference_quests.dart';
import 'listening_inference_event.dart';
import 'listening_inference_state.dart';

class ListeningInferenceBloc extends Bloc<ListeningInferenceEvent, ListeningInferenceState> {
  final GetListeningInferenceQuests getQuests;

  ListeningInferenceBloc({required this.getQuests}) : super(ListeningInferenceInitial()) {
    on<FetchListeningInferenceQuests>(_onFetchQuests);
    on<SubmitListeningInferenceAnswer>(_onSubmitAnswer);
    on<NextListeningInferenceQuestion>(_onNextQuestion);
    on<RestoreListeningInferenceLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchListeningInferenceQuests event,
    Emitter<ListeningInferenceState> emit,
  ) async {
    emit(ListeningInferenceLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(ListeningInferenceError(failure.message)),
      (quests) => emit(ListeningInferenceLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitListeningInferenceAnswer event,
    Emitter<ListeningInferenceState> emit,
  ) {
    final state = this.state;
    if (state is ListeningInferenceLoaded) {
      if (event.userIndex == event.correctIndex) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(ListeningInferenceGameOver());
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
    NextListeningInferenceQuestion event,
    Emitter<ListeningInferenceState> emit,
  ) {
    final state = this.state;
    if (state is ListeningInferenceLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(ListeningInferenceGameComplete(
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
    RestoreListeningInferenceLife event,
    Emitter<ListeningInferenceState> emit,
  ) {
    emit(ListeningInferenceInitial());
  }
}

