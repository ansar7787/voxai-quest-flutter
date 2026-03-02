import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/roleplay/emergency_hub/domain/usecases/get_emergency_hub_quests.dart';
import 'emergency_hub_event.dart';
import 'emergency_hub_state.dart';

class EmergencyHubBloc extends Bloc<EmergencyHubEvent, EmergencyHubState> {
  final GetEmergencyHubQuests getQuests;

  EmergencyHubBloc({required this.getQuests}) : super(EmergencyHubInitial()) {
        on<RestartLevel>((event, emit) => emit(EmergencyHubInitial()));
    on<FetchEmergencyHubQuests>(_onFetchQuests);
    on<SubmitEmergencyHubAnswer>(_onSubmitAnswer);
    on<NextEmergencyHubQuestion>(_onNextQuestion);
    on<RestoreEmergencyHubLife>(_onRestoreLife);
    on<EmergencyHubHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchEmergencyHubQuests event,
    Emitter<EmergencyHubState> emit,
  ) async {
    emit(EmergencyHubLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(const EmergencyHubError("Failed to load emergency hub quests")),
      (quests) => emit(EmergencyHubLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitEmergencyHubAnswer event,
    Emitter<EmergencyHubState> emit,
  ) {
    final state = this.state;
    if (state is EmergencyHubLoaded) {
      final isCorrect = event.isCorrect;
      final newLives = isCorrect ? state.livesRemaining : state.livesRemaining - 1;

      if (newLives <= 0) {
        emit(EmergencyHubGameOver());
      } else {
        emit(state.copyWith(
          livesRemaining: newLives,
          lastAnswerCorrect: isCorrect,
          xpEarned: isCorrect ? state.xpEarned + state.currentQuest.xpReward : state.xpEarned,
          coinsEarned: isCorrect ? state.coinsEarned + state.currentQuest.coinReward : state.coinsEarned,
        ));
      }
    }
  }

  void _onNextQuestion(
    NextEmergencyHubQuestion event,
    Emitter<EmergencyHubState> emit,
  ) {
    final state = this.state;
    if (state is EmergencyHubLoaded) {
      if (state.currentIndex + 1 < state.quests.length) {
        emit(state.copyWith(
          currentIndex: state.currentIndex + 1,
          lastAnswerCorrect: null,
        ));
      } else {
        emit(EmergencyHubGameComplete(
          xpEarned: state.xpEarned,
          coinsEarned: state.coinsEarned,
        ));
      }
    }
  }

  void _onRestoreLife(
    RestoreEmergencyHubLife event,
    Emitter<EmergencyHubState> emit,
  ) {
    final state = this.state;
    if (state is EmergencyHubLoaded) {
      emit(state.copyWith(livesRemaining: 3));
    }
  }

  void _onHintUsed(
    EmergencyHubHintUsed event,
    Emitter<EmergencyHubState> emit,
  ) {
    // Implement hint logic if needed
  }
}

