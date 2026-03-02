import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/roleplay/gourmet_order/domain/usecases/get_gourmet_order_quests.dart';
import 'gourmet_order_event.dart';
import 'gourmet_order_state.dart';

class GourmetOrderBloc extends Bloc<GourmetOrderEvent, GourmetOrderState> {
  final GetGourmetOrderQuests getQuests;

  GourmetOrderBloc({required this.getQuests}) : super(GourmetOrderInitial()) {
        on<RestartLevel>((event, emit) => emit(GourmetOrderInitial()));
    on<FetchGourmetOrderQuests>(_onFetchQuests);
    on<SubmitGourmetOrderAnswer>(_onSubmitAnswer);
    on<NextGourmetOrderQuestion>(_onNextQuestion);
    on<RestoreGourmetOrderLife>(_onRestoreLife);
    on<GourmetOrderHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchGourmetOrderQuests event,
    Emitter<GourmetOrderState> emit,
  ) async {
    emit(GourmetOrderLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(const GourmetOrderError("Failed to load gourmet order quests")),
      (quests) => emit(GourmetOrderLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitGourmetOrderAnswer event,
    Emitter<GourmetOrderState> emit,
  ) {
    final state = this.state;
    if (state is GourmetOrderLoaded) {
      final isCorrect = event.isCorrect;
      final newLives = isCorrect ? state.livesRemaining : state.livesRemaining - 1;

      if (newLives <= 0) {
        emit(GourmetOrderGameOver());
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
    NextGourmetOrderQuestion event,
    Emitter<GourmetOrderState> emit,
  ) {
    final state = this.state;
    if (state is GourmetOrderLoaded) {
      if (state.currentIndex + 1 < state.quests.length) {
        emit(state.copyWith(
          currentIndex: state.currentIndex + 1,
          lastAnswerCorrect: null,
        ));
      } else {
        emit(GourmetOrderGameComplete(
          xpEarned: state.xpEarned,
          coinsEarned: state.coinsEarned,
        ));
      }
    }
  }

  void _onRestoreLife(
    RestoreGourmetOrderLife event,
    Emitter<GourmetOrderState> emit,
  ) {
    final state = this.state;
    if (state is GourmetOrderLoaded) {
      emit(state.copyWith(livesRemaining: 3));
    }
  }

  void _onHintUsed(
    GourmetOrderHintUsed event,
    Emitter<GourmetOrderState> emit,
  ) {
    // Implement hint logic if needed
  }
}

