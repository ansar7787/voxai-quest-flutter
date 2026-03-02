import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/roleplay/branching_dialogue/domain/usecases/get_branching_dialogue_quests.dart';
import 'branching_dialogue_event.dart';
import 'branching_dialogue_state.dart';

class BranchingDialogueBloc extends Bloc<BranchingDialogueEvent, BranchingDialogueState> {
  final GetBranchingDialogueQuests getQuests;

  BranchingDialogueBloc({required this.getQuests}) : super(BranchingDialogueInitial()) {
        on<RestartLevel>((event, emit) => emit(BranchingDialogueInitial()));
    on<FetchBranchingDialogueQuests>(_onFetchQuests);
    on<SubmitBranchingDialogueAnswer>(_onSubmitAnswer);
    on<NextBranchingDialogueQuestion>(_onNextQuestion);
    on<RestoreBranchingDialogueLife>(_onRestoreLife);
    on<BranchingDialogueHintUsed>(_onHintUsed);
  }

  Future<void> _onFetchQuests(
    FetchBranchingDialogueQuests event,
    Emitter<BranchingDialogueState> emit,
  ) async {
    emit(BranchingDialogueLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(const BranchingDialogueError("Failed to load branching dialogue quests")),
      (quests) => emit(BranchingDialogueLoaded(quests: quests)),
    );
  }

  void _onSubmitAnswer(
    SubmitBranchingDialogueAnswer event,
    Emitter<BranchingDialogueState> emit,
  ) {
    final state = this.state;
    if (state is BranchingDialogueLoaded) {
      final isCorrect = event.isCorrect;
      final newLives = isCorrect ? state.livesRemaining : state.livesRemaining - 1;

      if (newLives <= 0) {
        emit(BranchingDialogueGameOver());
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
    NextBranchingDialogueQuestion event,
    Emitter<BranchingDialogueState> emit,
  ) {
    final state = this.state;
    if (state is BranchingDialogueLoaded) {
      if (state.currentIndex + 1 < state.quests.length) {
        emit(state.copyWith(
          currentIndex: state.currentIndex + 1,
          lastAnswerCorrect: null,
        ));
      } else {
        emit(BranchingDialogueGameComplete(
          xpEarned: state.xpEarned,
          coinsEarned: state.coinsEarned,
        ));
      }
    }
  }

  void _onRestoreLife(
    RestoreBranchingDialogueLife event,
    Emitter<BranchingDialogueState> emit,
  ) {
    final state = this.state;
    if (state is BranchingDialogueLoaded) {
      emit(state.copyWith(livesRemaining: 3));
    }
  }

  void _onHintUsed(
    BranchingDialogueHintUsed event,
    Emitter<BranchingDialogueState> emit,
  ) {
    // Implement hint logic if needed
  }
}

