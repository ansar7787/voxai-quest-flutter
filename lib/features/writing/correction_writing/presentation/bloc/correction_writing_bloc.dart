import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/writing/correction_writing/domain/usecases/get_correction_writing_quests.dart';
import 'correction_writing_event.dart';
import 'correction_writing_state.dart';

class CorrectionWritingBloc
    extends Bloc<CorrectionWritingEvent, CorrectionWritingState> {
  final GetCorrectionWritingQuests getQuests;

  CorrectionWritingBloc({required this.getQuests})
    : super(CorrectionWritingInitial()) {
    on<FetchCorrectionWritingQuests>(_onFetchQuests);
    on<SubmitCorrectionWritingAnswer>(_onSubmitAnswer);
    on<NextCorrectionWritingQuestion>(_onNextQuestion);
    on<RestoreCorrectionWritingLife>(_onRestoreLife);
    on<CorrectionWritingHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchCorrectionWritingQuests event,
    Emitter<CorrectionWritingState> emit,
  ) async {
    emit(CorrectionWritingLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(CorrectionWritingError(failure.message)),
      (quests) => emit(CorrectionWritingLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitCorrectionWritingAnswer event,
    Emitter<CorrectionWritingState> emit,
  ) {
    final state = this.state;
    if (state is CorrectionWritingLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(CorrectionWritingGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextCorrectionWritingQuestion event,
    Emitter<CorrectionWritingState> emit,
  ) {
    final state = this.state;
    if (state is CorrectionWritingLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          CorrectionWritingGameComplete(
            xpEarned: totalQuests * 10,
            coinsEarned: totalQuests * 5,
          ),
        );
      } else {
        emit(
          state.copyWith(
            currentIndex: nextIndex,
            lastAnswerCorrect: null,
            hintUsed: false,
          ),
        );
      }
    }
  }

  void _onRestoreLife(
    RestoreCorrectionWritingLife event,
    Emitter<CorrectionWritingState> emit,
  ) {
    emit(CorrectionWritingInitial());
  }

  void _onHintUsed(
    CorrectionWritingHintUsed event,
    Emitter<CorrectionWritingState> emit,
  ) {
    final state = this.state;
    if (state is CorrectionWritingLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
