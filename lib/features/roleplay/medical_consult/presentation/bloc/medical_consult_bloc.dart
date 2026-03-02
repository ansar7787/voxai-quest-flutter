import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/roleplay/medical_consult/domain/usecases/get_medical_consult_quests.dart';
import 'medical_consult_event.dart';
import 'medical_consult_state.dart';

class MedicalConsultBloc
    extends Bloc<MedicalConsultEvent, MedicalConsultState> {
  final GetMedicalConsultQuests getQuests;

  MedicalConsultBloc({required this.getQuests})
    : super(MedicalConsultInitial()) {
    on<RestartLevel>((event, emit) => emit(MedicalConsultInitial()));
    on<FetchMedicalConsultQuests>(_onFetchQuests);
    on<SubmitMedicalConsultAnswer>(_onSubmitAnswer);
    on<NextMedicalConsultQuestion>(_onNextQuestion);
    on<RestoreMedicalConsultLife>(_onRestoreLife);
    on<MedicalConsultHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchMedicalConsultQuests event,
    Emitter<MedicalConsultState> emit,
  ) async {
    emit(MedicalConsultLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(
        const MedicalConsultError("Failed to load medical consult quests"),
      ),
      (quests) => emit(MedicalConsultLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitMedicalConsultAnswer event,
    Emitter<MedicalConsultState> emit,
  ) {
    final state = this.state;
    if (state is MedicalConsultLoaded) {
      final isCorrect = event.isCorrect;
      final newLives = isCorrect
          ? state.livesRemaining
          : state.livesRemaining - 1;

      if (newLives <= 0) {
        emit(MedicalConsultGameOver());
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
    NextMedicalConsultQuestion event,
    Emitter<MedicalConsultState> emit,
  ) {
    final state = this.state;
    if (state is MedicalConsultLoaded) {
      if (state.currentIndex + 1 < state.quests.length) {
        emit(
          state.copyWith(
            currentIndex: state.currentIndex + 1,
            lastAnswerCorrect: null,
          ),
        );
      } else {
        emit(
          MedicalConsultGameComplete(
            xpEarned: state.xpEarned,
            coinsEarned: state.coinsEarned,
          ),
        );
      }
    }
  }

  void _onRestoreLife(
    RestoreMedicalConsultLife event,
    Emitter<MedicalConsultState> emit,
  ) {
    final state = this.state;
    if (state is MedicalConsultLoaded) {
      emit(state.copyWith(livesRemaining: 3));
    }
  }

  void _onHintUsed(
    MedicalConsultHintUsed event,
    Emitter<MedicalConsultState> emit,
  ) {
    // Implement hint logic if needed
  }
}
