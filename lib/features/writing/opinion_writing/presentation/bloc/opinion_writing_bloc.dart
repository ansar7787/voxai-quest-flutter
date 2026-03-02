import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/writing/opinion_writing/domain/usecases/get_opinion_writing_quests.dart';
import 'opinion_writing_event.dart';
import 'opinion_writing_state.dart';

class OpinionWritingBloc
    extends Bloc<OpinionWritingEvent, OpinionWritingState> {
  final GetOpinionWritingQuests getQuests;

  OpinionWritingBloc({required this.getQuests})
    : super(OpinionWritingInitial()) {
    on<FetchOpinionWritingQuests>(_onFetchQuests);
    on<SubmitOpinionWritingAnswer>(_onSubmitAnswer);
    on<NextOpinionWritingQuestion>(_onNextQuestion);
    on<RestoreOpinionWritingLife>(_onRestoreLife);
    on<OpinionWritingHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchOpinionWritingQuests event,
    Emitter<OpinionWritingState> emit,
  ) async {
    emit(OpinionWritingLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(OpinionWritingError(failure.message)),
      (quests) => emit(OpinionWritingLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitOpinionWritingAnswer event,
    Emitter<OpinionWritingState> emit,
  ) {
    final state = this.state;
    if (state is OpinionWritingLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(OpinionWritingGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextOpinionWritingQuestion event,
    Emitter<OpinionWritingState> emit,
  ) {
    final state = this.state;
    if (state is OpinionWritingLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          OpinionWritingGameComplete(
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
    RestoreOpinionWritingLife event,
    Emitter<OpinionWritingState> emit,
  ) {
    emit(OpinionWritingInitial());
  }

  void _onHintUsed(
    OpinionWritingHintUsed event,
    Emitter<OpinionWritingState> emit,
  ) {
    final state = this.state;
    if (state is OpinionWritingLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
