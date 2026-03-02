import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/writing/short_answer_writing/domain/usecases/get_short_answer_writing_quests.dart';
import 'short_answer_writing_event.dart';
import 'short_answer_writing_state.dart';

class ShortAnswerWritingBloc
    extends Bloc<ShortAnswerWritingEvent, ShortAnswerWritingState> {
  final GetShortAnswerWritingQuests getQuests;

  ShortAnswerWritingBloc({required this.getQuests})
    : super(ShortAnswerWritingInitial()) {
    on<FetchShortAnswerWritingQuests>(_onFetchQuests);
    on<SubmitShortAnswerWritingAnswer>(_onSubmitAnswer);
    on<NextShortAnswerWritingQuestion>(_onNextQuestion);
    on<RestoreShortAnswerWritingLife>(_onRestoreLife);
    on<ShortAnswerWritingHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchShortAnswerWritingQuests event,
    Emitter<ShortAnswerWritingState> emit,
  ) async {
    emit(ShortAnswerWritingLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(ShortAnswerWritingError(failure.message)),
      (quests) => emit(ShortAnswerWritingLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitShortAnswerWritingAnswer event,
    Emitter<ShortAnswerWritingState> emit,
  ) {
    final state = this.state;
    if (state is ShortAnswerWritingLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(ShortAnswerWritingGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextShortAnswerWritingQuestion event,
    Emitter<ShortAnswerWritingState> emit,
  ) {
    final state = this.state;
    if (state is ShortAnswerWritingLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          ShortAnswerWritingGameComplete(
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
    RestoreShortAnswerWritingLife event,
    Emitter<ShortAnswerWritingState> emit,
  ) {
    emit(ShortAnswerWritingInitial());
  }

  void _onHintUsed(
    ShortAnswerWritingHintUsed event,
    Emitter<ShortAnswerWritingState> emit,
  ) {
    final state = this.state;
    if (state is ShortAnswerWritingLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
