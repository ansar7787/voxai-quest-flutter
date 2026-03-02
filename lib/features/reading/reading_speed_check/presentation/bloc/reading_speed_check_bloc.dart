import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/reading/reading_speed_check/domain/usecases/get_reading_speed_check_quests.dart';
import 'reading_speed_check_event.dart';
import 'reading_speed_check_state.dart';

class ReadingSpeedCheckBloc
    extends Bloc<ReadingSpeedCheckEvent, ReadingSpeedCheckState> {
  final GetReadingSpeedCheckQuests getQuests;

  ReadingSpeedCheckBloc({required this.getQuests})
    : super(ReadingSpeedCheckInitial()) {
    on<FetchReadingSpeedCheckQuests>(_onFetchQuests);
    on<SubmitReadingSpeedCheckAnswer>(_onSubmitAnswer);
    on<NextReadingSpeedCheckQuestion>(_onNextQuestion);
    on<RestoreReadingSpeedCheckLife>(_onRestoreLife);
    on<ReadingSpeedCheckHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchReadingSpeedCheckQuests event,
    Emitter<ReadingSpeedCheckState> emit,
  ) async {
    emit(ReadingSpeedCheckLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(ReadingSpeedCheckError(failure.message)),
      (quests) => emit(ReadingSpeedCheckLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitReadingSpeedCheckAnswer event,
    Emitter<ReadingSpeedCheckState> emit,
  ) {
    final state = this.state;
    if (state is ReadingSpeedCheckLoaded) {
      if (event.isCorrect) {
        emit(state.copyWith(lastAnswerCorrect: true));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(ReadingSpeedCheckGameOver());
        } else {
          emit(
            state.copyWith(livesRemaining: newLives, lastAnswerCorrect: false),
          );
        }
      }
    }
  }

  void _onNextQuestion(
    NextReadingSpeedCheckQuestion event,
    Emitter<ReadingSpeedCheckState> emit,
  ) {
    final state = this.state;
    if (state is ReadingSpeedCheckLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(
          ReadingSpeedCheckGameComplete(
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
    RestoreReadingSpeedCheckLife event,
    Emitter<ReadingSpeedCheckState> emit,
  ) {
    emit(ReadingSpeedCheckInitial());
  }

  void _onHintUsed(
    ReadingSpeedCheckHintUsed event,
    Emitter<ReadingSpeedCheckState> emit,
  ) {
    final state = this.state;
    if (state is ReadingSpeedCheckLoaded) {
      emit(state.copyWith(hintUsed: true));
    }
  }
}
