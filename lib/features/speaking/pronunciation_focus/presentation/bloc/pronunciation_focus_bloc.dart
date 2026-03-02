import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/speaking/pronunciation_focus/domain/usecases/get_pronunciation_focus_quests.dart';
import 'pronunciation_focus_event.dart';
import 'pronunciation_focus_state.dart';

class PronunciationFocusBloc
    extends Bloc<PronunciationFocusEvent, PronunciationFocusState> {
  final GetPronunciationFocusQuests getQuests;

  PronunciationFocusBloc({required this.getQuests})
    : super(PronunciationFocusInitial()) {
    on<FetchPronunciationFocusQuests>(_onFetchQuests);
    on<SubmitPronunciationFocusAnswer>(_onSubmitAnswer);
    on<NextPronunciationFocusQuestion>(_onNextQuestion);
    on<RestorePronunciationFocusLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchPronunciationFocusQuests event,
    Emitter<PronunciationFocusState> emit,
  ) async {
    emit(PronunciationFocusLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(PronunciationFocusError(failure.message)),
      (quests) => emit(PronunciationFocusLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitPronunciationFocusAnswer event,
    Emitter<PronunciationFocusState> emit,
  ) {
    final state = this.state;
    if (state is PronunciationFocusLoaded) {
      if (event.isCorrect) {
        emit(
          state.copyWith(
            lastAnswerCorrect: true,
            lastAccuracyScore: event.accuracyScore,
          ),
        );
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(PronunciationFocusGameOver());
        } else {
          emit(
            state.copyWith(
              livesRemaining: newLives,
              lastAnswerCorrect: false,
              lastAccuracyScore: event.accuracyScore,
            ),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextPronunciationFocusQuestion event,
    Emitter<PronunciationFocusState> emit,
  ) {
    final state = this.state;
    if (state is PronunciationFocusLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          PronunciationFocusGameComplete(
            xpEarned: totalQuests * 10,
            coinsEarned: totalQuests * 5,
          ),
        );
      } else {
        emit(
          state.copyWith(
            currentIndex: nextIndex,
            lastAnswerCorrect: null,
            lastAccuracyScore: null,
          ),
        );
      }
    }
  }

  void _onRestoreLife(
    RestorePronunciationFocusLife event,
    Emitter<PronunciationFocusState> emit,
  ) {
    emit(PronunciationFocusInitial());
  }
}
