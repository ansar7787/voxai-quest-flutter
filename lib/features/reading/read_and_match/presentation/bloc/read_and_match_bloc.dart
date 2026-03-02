import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/reading/read_and_match/domain/usecases/get_read_and_match_quests.dart';
import 'read_and_match_event.dart';
import 'read_and_match_state.dart';

class ReadAndMatchBloc extends Bloc<ReadAndMatchEvent, ReadAndMatchState> {
  final GetReadAndMatchQuests getQuests;

  ReadAndMatchBloc({required this.getQuests}) : super(ReadAndMatchInitial()) {
    on<FetchReadAndMatchQuests>(_onFetchQuests);
    on<SubmitReadAndMatchAnswer>(_onSubmitAnswer);
    on<NextReadAndMatchQuestion>(_onNextQuestion);
    on<RestoreReadAndMatchLife>(_onRestoreLife);
    on<ReadAndMatchHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchReadAndMatchQuests event,
    Emitter<ReadAndMatchState> emit,
  ) async {
    emit(ReadAndMatchLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(ReadAndMatchError(failure.message)),
      (quests) => emit(ReadAndMatchLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitReadAndMatchAnswer event,
    Emitter<ReadAndMatchState> emit,
  ) {
    final state = this.state;
    if (state is ReadAndMatchLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(ReadAndMatchGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextReadAndMatchQuestion event,
    Emitter<ReadAndMatchState> emit,
  ) {
    final state = this.state;
    if (state is ReadAndMatchLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          ReadAndMatchGameComplete(
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
    RestoreReadAndMatchLife event,
    Emitter<ReadAndMatchState> emit,
  ) {
    emit(ReadAndMatchInitial());
  }

  void _onHintUsed(
    ReadAndMatchHintUsed event,
    Emitter<ReadAndMatchState> emit,
  ) {
    final state = this.state;
    if (state is ReadAndMatchLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
