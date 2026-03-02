import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/speaking/dialogue_roleplay/domain/entities/dialogue_roleplay_quest.dart';
import 'package:voxai_quest/features/speaking/dialogue_roleplay/domain/usecases/get_dialogue_roleplay_quests.dart';
import 'dialogue_roleplay_event.dart';
import 'dialogue_roleplay_state.dart';

class DialogueRoleplayBloc extends Bloc<DialogueRoleplayEvent, DialogueRoleplayState> {
  final GetDialogueRoleplayQuests getQuests;

  DialogueRoleplayBloc({required this.getQuests}) : super(DialogueRoleplayInitial()) {
    on<FetchDialogueRoleplayQuests>(_onFetchQuests);
    on<SubmitDialogueRoleplayAnswer>(_onSubmitAnswer);
    on<NextDialogueRoleplayQuestion>(_onNextQuestion);
    on<NextDialogueTurn>(_onNextTurn);
    on<RestoreDialogueRoleplayLife>(_onRestoreLife);
  }

  Future<void> _onFetchQuests(
    FetchDialogueRoleplayQuests event,
    Emitter<DialogueRoleplayState> emit,
  ) async {
    emit(DialogueRoleplayLoading());
    final result = await getQuests(event.level);
    result.fold(
      (failure) => emit(DialogueRoleplayError(failure.message)),
      (quests) {
        if (quests.isEmpty) {
          emit(const DialogueRoleplayError("No quests available"));
          return;
        }
        final initialQuest = quests[0];
        List<DialogueTurn> history = [];
        int firstUserTurnIndex = 0;

        // Add all AI turns before the first user turn to history
        for (int i = 0; i < initialQuest.turns!.length; i++) {
          if (initialQuest.turns![i].isUser) {
            firstUserTurnIndex = i;
            break;
          }
          history.add(initialQuest.turns![i]);
        }

        emit(DialogueRoleplayLoaded(
          quests: quests,
          currentTurnIndex: firstUserTurnIndex,
          conversationHistory: history,
        ));
      },
    );
  }

  void _onSubmitAnswer(
    SubmitDialogueRoleplayAnswer event,
    Emitter<DialogueRoleplayState> emit,
  ) {
    final state = this.state;
    if (state is DialogueRoleplayLoaded) {
      if (event.isCorrect) {
        final currentTurn = state.currentTurn;
        final newHistory = List<DialogueTurn>.from(state.conversationHistory)..add(currentTurn);
        emit(state.copyWith(
          lastAnswerCorrect: true,
          conversationHistory: newHistory,
        ));
      } else {
        final newLives = state.livesRemaining - 1;
        if (newLives <= 0) {
          emit(DialogueRoleplayGameOver());
        } else {
          emit(state.copyWith(
            livesRemaining: newLives,
            lastAnswerCorrect: false,
          ));
        }
      }
    }
  }

  void _onNextTurn(
    NextDialogueTurn event,
    Emitter<DialogueRoleplayState> emit,
  ) {
    final state = this.state;
    if (state is DialogueRoleplayLoaded) {
      int nextTurnIndex = state.currentTurnIndex + 1;
      final turns = state.currentQuest.turns!;
      List<DialogueTurn> newHistory = List<DialogueTurn>.from(state.conversationHistory);

      while (nextTurnIndex < turns.length && !turns[nextTurnIndex].isUser) {
        newHistory.add(turns[nextTurnIndex]);
        nextTurnIndex++;
      }

      if (nextTurnIndex >= turns.length) {
        add(NextDialogueRoleplayQuestion());
      } else {
        emit(state.copyWith(
          currentTurnIndex: nextTurnIndex,
          conversationHistory: newHistory,
          lastAnswerCorrect: null,
        ));
      }
    }
  }

  void _onNextQuestion(
    NextDialogueRoleplayQuestion event,
    Emitter<DialogueRoleplayState> emit,
  ) {
    final state = this.state;
    if (state is DialogueRoleplayLoaded) {
      final nextIndex = state.currentIndex + 1;
      if (nextIndex >= state.quests.length) {
        final totalQuests = state.quests.length;
        emit(DialogueRoleplayGameComplete(
          xpEarned: totalQuests * 20,
          coinsEarned: totalQuests * 10,
        ));
      } else {
        final nextQuest = state.quests[nextIndex];
        List<DialogueTurn> history = [];
        int firstUserTurnIndex = 0;

        for (int i = 0; i < nextQuest.turns!.length; i++) {
          if (nextQuest.turns![i].isUser) {
            firstUserTurnIndex = i;
            break;
          }
          history.add(nextQuest.turns![i]);
        }

        emit(state.copyWith(
          currentIndex: nextIndex,
          currentTurnIndex: firstUserTurnIndex,
          conversationHistory: history,
          lastAnswerCorrect: null,
        ));
      }
    }
  }

  void _onRestoreLife(
    RestoreDialogueRoleplayLife event,
    Emitter<DialogueRoleplayState> emit,
  ) {
    emit(DialogueRoleplayInitial());
  }
}
