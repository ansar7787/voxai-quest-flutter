import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/reading/true_false_reading/domain/usecases/get_true_false_reading_quests.dart';
import 'true_false_reading_event.dart';
import 'true_false_reading_state.dart';

class TrueFalseReadingBloc
    extends Bloc<TrueFalseReadingEvent, TrueFalseReadingState> {
  final GetTrueFalseReadingQuests getQuests;

  TrueFalseReadingBloc({required this.getQuests})
    : super(TrueFalseReadingInitial()) {
    on<FetchTrueFalseReadingQuests>(_onFetchQuests);
    on<SubmitTrueFalseReadingAnswer>(_onSubmitAnswer);
    on<NextTrueFalseReadingQuestion>(_onNextQuestion);
    on<RestoreTrueFalseReadingLife>(_onRestoreLife);
    on<TrueFalseReadingHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchTrueFalseReadingQuests event,
    Emitter<TrueFalseReadingState> emit,
  ) async {
    emit(TrueFalseReadingLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(TrueFalseReadingError(failure.message)),
      (quests) => emit(TrueFalseReadingLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitTrueFalseReadingAnswer event,
    Emitter<TrueFalseReadingState> emit,
  ) {
    final state = this.state;
    if (state is TrueFalseReadingLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(TrueFalseReadingGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextTrueFalseReadingQuestion event,
    Emitter<TrueFalseReadingState> emit,
  ) {
    final state = this.state;
    if (state is TrueFalseReadingLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          TrueFalseReadingGameComplete(
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
    RestoreTrueFalseReadingLife event,
    Emitter<TrueFalseReadingState> emit,
  ) {
    emit(TrueFalseReadingInitial());
  }

  void _onHintUsed(
    TrueFalseReadingHintUsed event,
    Emitter<TrueFalseReadingState> emit,
  ) {
    final state = this.state;
    if (state is TrueFalseReadingLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
