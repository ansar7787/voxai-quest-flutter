import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/listening/emotion_recognition/domain/usecases/get_emotion_recognition_quests.dart';
import 'emotion_recognition_event.dart';
import 'emotion_recognition_state.dart';

class EmotionRecognitionBloc
    extends Bloc<EmotionRecognitionEvent, EmotionRecognitionState> {
  final GetEmotionRecognitionQuests getQuests;

  EmotionRecognitionBloc({required this.getQuests})
    : super(EmotionRecognitionInitial()) {
    on<FetchEmotionRecognitionQuests>(_onFetchQuests);
    on<SubmitEmotionRecognitionAnswer>(_onSubmitAnswer);
    on<NextEmotionRecognitionQuestion>(_onNextQuestion);
    on<RestoreEmotionRecognitionLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchEmotionRecognitionQuests event,
    Emitter<EmotionRecognitionState> emit,
  ) async {
    emit(EmotionRecognitionLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(EmotionRecognitionError(failure.message)),
      (quests) => emit(EmotionRecognitionLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitEmotionRecognitionAnswer event,
    Emitter<EmotionRecognitionState> emit,
  ) {
    final state = this.state;
    if (state is EmotionRecognitionLoaded) {
      if (event.userIndex == event.correctIndex) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(EmotionRecognitionGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextEmotionRecognitionQuestion event,
    Emitter<EmotionRecognitionState> emit,
  ) {
    final state = this.state;
    if (state is EmotionRecognitionLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          EmotionRecognitionGameComplete(
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
    RestoreEmotionRecognitionLife event,
    Emitter<EmotionRecognitionState> emit,
  ) {
    emit(EmotionRecognitionInitial());
  }
}
