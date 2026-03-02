import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/roleplay/situational_response/domain/usecases/get_situational_response_quests.dart';
import 'situational_response_event.dart';
import 'situational_response_state.dart';

class SituationalResponseBloc
    extends Bloc<SituationalResponseEvent, SituationalResponseState> {
  final GetSituationalResponseQuests getQuests;

  SituationalResponseBloc({required this.getQuests})
    : super(SituationalResponseInitial()) {
    on<RestartLevel>((event, emit) => emit(SituationalResponseInitial()));
    on<FetchSituationalResponseQuests>(_onFetchQuests);
    on<SubmitSituationalResponseAnswer>(_onSubmitAnswer);
    on<NextSituationalResponseQuestion>(_onNextQuestion);
    on<RestoreSituationalResponseLife>(_onRestoreLife);
    on<SituationalResponseHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchSituationalResponseQuests event,
    Emitter<SituationalResponseState> emit,
  ) async {
    emit(SituationalResponseLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(
        const SituationalResponseError(
          "Failed to load situational response quests",
        ),
      ),
      (quests) => emit(SituationalResponseLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitSituationalResponseAnswer event,
    Emitter<SituationalResponseState> emit,
  ) {
    final state = this.state;
    if (state is SituationalResponseLoaded) {
      final isCorrect = event.isCorrect;
      final newLives = isCorrect
          ? state.livesRemaining
          : state.livesRemaining - 1;

      if (newLives <= 0) {
        emit(SituationalResponseGameOver());
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
    NextSituationalResponseQuestion event,
    Emitter<SituationalResponseState> emit,
  ) {
    final state = this.state;
    if (state is SituationalResponseLoaded) {
      if (state.currentIndex + 1 < state.quests.length) {
        emit(
          state.copyWith(
            currentIndex: state.currentIndex + 1,
            lastAnswerCorrect: null,
          ),
        );
      } else {
        emit(
          SituationalResponseGameComplete(
            xpEarned: state.xpEarned,
            coinsEarned: state.coinsEarned,
          ),
        );
      }
    }
  }

  void _onRestoreLife(
    RestoreSituationalResponseLife event,
    Emitter<SituationalResponseState> emit,
  ) {
    final state = this.state;
    if (state is SituationalResponseLoaded) {
      emit(state.copyWith(livesRemaining: 3));
    }
  }

  void _onHintUsed(
    SituationalResponseHintUsed event,
    Emitter<SituationalResponseState> emit,
  ) {
    // Implement hint logic if needed
  }
}
