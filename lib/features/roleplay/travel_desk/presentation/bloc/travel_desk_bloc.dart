import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/roleplay/travel_desk/domain/usecases/get_travel_desk_quests.dart';
import 'travel_desk_event.dart';
import 'travel_desk_state.dart';

class TravelDeskBloc extends Bloc<TravelDeskEvent, TravelDeskState> {
  final GetTravelDeskQuests getQuests;

  TravelDeskBloc({required this.getQuests}) : super(TravelDeskInitial()) {
    on<RestartLevel>((event, emit) => emit(TravelDeskInitial()));
    on<FetchTravelDeskQuests>(_onFetchQuests);
    on<SubmitTravelDeskAnswer>(_onSubmitAnswer);
    on<NextTravelDeskQuestion>(_onNextQuestion);
    on<RestoreTravelDeskLife>(_onRestoreLife);
    on<TravelDeskHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchTravelDeskQuests event,
    Emitter<TravelDeskState> emit,
  ) async {
    emit(TravelDeskLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) =>
          emit(const TravelDeskError("Failed to load travel desk quests")),
      (quests) => emit(TravelDeskLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitTravelDeskAnswer event,
    Emitter<TravelDeskState> emit,
  ) {
    final state = this.state;
    if (state is TravelDeskLoaded) {
      final isCorrect = event.isCorrect;
      final newLives = isCorrect
          ? state.livesRemaining
          : state.livesRemaining - 1;

      if (newLives <= 0) {
        emit(TravelDeskGameOver());
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
    NextTravelDeskQuestion event,
    Emitter<TravelDeskState> emit,
  ) {
    final state = this.state;
    if (state is TravelDeskLoaded) {
      if (state.currentIndex + 1 < state.quests.length) {
        emit(
          state.copyWith(
            currentIndex: state.currentIndex + 1,
            lastAnswerCorrect: null,
          ),
        );
      } else {
        emit(
          TravelDeskGameComplete(
            xpEarned: state.xpEarned,
            coinsEarned: state.coinsEarned,
          ),
        );
      }
    }
  }

  void _onRestoreLife(
    RestoreTravelDeskLife event,
    Emitter<TravelDeskState> emit,
  ) {
    final state = this.state;
    if (state is TravelDeskLoaded) {
      emit(state.copyWith(livesRemaining: 3));
    }
  }

  void _onHintUsed(TravelDeskHintUsed event, Emitter<TravelDeskState> emit) {
    // Implement hint logic if needed
  }
}
