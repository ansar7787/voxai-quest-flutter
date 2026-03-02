import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/roleplay/elevator_pitch/domain/usecases/get_elevator_pitch_quests.dart';
import 'elevator_pitch_event.dart';
import 'elevator_pitch_state.dart';

class ElevatorPitchBloc extends Bloc<ElevatorPitchEvent, ElevatorPitchState> {
  final GetElevatorPitchQuests getQuests;

  ElevatorPitchBloc({required this.getQuests}) : super(ElevatorPitchInitial()) {
    on<RestartLevel>((event, emit) => emit(ElevatorPitchInitial()));
    on<FetchElevatorPitchQuests>(_onFetchQuests);
    on<SubmitElevatorPitchAnswer>(_onSubmitAnswer);
    on<NextElevatorPitchQuestion>(_onNextQuestion);
    on<RestoreElevatorPitchLife>(_onRestoreLife);
    on<ElevatorPitchHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchElevatorPitchQuests event,
    Emitter<ElevatorPitchState> emit,
  ) async {
    emit(ElevatorPitchLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(
        const ElevatorPitchError("Failed to load elevator pitch quests"),
      ),
      (quests) => emit(ElevatorPitchLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitElevatorPitchAnswer event,
    Emitter<ElevatorPitchState> emit,
  ) {
    final state = this.state;
    if (state is ElevatorPitchLoaded) {
      final isCorrect = event.isCorrect;
      final newLives = isCorrect
          ? state.livesRemaining
          : state.livesRemaining - 1;

      if (newLives <= 0) {
        emit(ElevatorPitchGameOver());
      } else {
        emit(
          state.copyWith(
            livesRemaining: newLives,
            lastAnswerCorrect: isCorrect,
            xpEarned: isCorrect
                ? state.xpEarned + state.currentQuest.xpReward
                : state.xpEarned,
            coinsEarned: isCorrect
                ? state.coinsEarned + state.currentQuest.coinReward
                : state.coinsEarned,
          ),
        );
      }
    }
  }

  void _onNextQuestion(
    NextElevatorPitchQuestion event,
    Emitter<ElevatorPitchState> emit,
  ) {
    final state = this.state;
    if (state is ElevatorPitchLoaded) {
      if (state.currentIndex + 1 < state.quests.length) {
        emit(
          state.copyWith(
            currentIndex: state.currentIndex + 1,
            lastAnswerCorrect: null,
          ),
        );
      } else {
        emit(
          ElevatorPitchGameComplete(
            xpEarned: state.xpEarned,
            coinsEarned: state.coinsEarned,
          ),
        );
      }
    }
  }

  void _onRestoreLife(
    RestoreElevatorPitchLife event,
    Emitter<ElevatorPitchState> emit,
  ) {
    final state = this.state;
    if (state is ElevatorPitchLoaded) {
      emit(state.copyWith(livesRemaining: 3));
    }
  }

  void _onHintUsed(
    ElevatorPitchHintUsed event,
    Emitter<ElevatorPitchState> emit,
  ) {
    // Implement hint logic if needed
  }
}
