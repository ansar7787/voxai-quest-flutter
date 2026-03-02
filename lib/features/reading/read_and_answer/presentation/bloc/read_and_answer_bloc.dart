import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/reading/read_and_answer/domain/usecases/get_read_and_answer_quests.dart';
import 'read_and_answer_event.dart';
import 'read_and_answer_state.dart';

class ReadAndAnswerBloc extends Bloc<ReadAndAnswerEvent, ReadAndAnswerState> {
  final GetReadAndAnswerQuests getQuests;

  ReadAndAnswerBloc({required this.getQuests}) : super(ReadAndAnswerInitial()) {
    on<FetchReadAndAnswerQuests>(_onFetchQuests);
    on<SubmitReadAndAnswerAnswer>(_onSubmitAnswer);
    on<NextReadAndAnswerQuestion>(_onNextQuestion);
    on<RestoreReadAndAnswerLife>(_onRestoreLife);
    on<ReadAndAnswerHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchReadAndAnswerQuests event,
    Emitter<ReadAndAnswerState> emit,
  ) async {
    emit(ReadAndAnswerLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(ReadAndAnswerError(failure.message)),
      (quests) => emit(ReadAndAnswerLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitReadAndAnswerAnswer event,
    Emitter<ReadAndAnswerState> emit,
  ) {
    final state = this.state;
    if (state is ReadAndAnswerLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(ReadAndAnswerGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextReadAndAnswerQuestion event,
    Emitter<ReadAndAnswerState> emit,
  ) {
    final state = this.state;
    if (state is ReadAndAnswerLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          ReadAndAnswerGameComplete(
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
    RestoreReadAndAnswerLife event,
    Emitter<ReadAndAnswerState> emit,
  ) {
    emit(ReadAndAnswerInitial());
  }

  void _onHintUsed(
    ReadAndAnswerHintUsed event,
    Emitter<ReadAndAnswerState> emit,
  ) {
    final state = this.state;
    if (state is ReadAndAnswerLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
