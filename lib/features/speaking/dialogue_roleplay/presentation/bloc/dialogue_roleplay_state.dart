import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/speaking/dialogue_roleplay/domain/entities/dialogue_roleplay_quest.dart';

abstract class DialogueRoleplayState extends Equatable {
  const DialogueRoleplayState();

  @override
  List<Object?> get props => [];
}

class DialogueRoleplayInitial extends DialogueRoleplayState {}

class DialogueRoleplayLoading extends DialogueRoleplayState {}

class DialogueRoleplayLoaded extends DialogueRoleplayState {
  final List<DialogueRoleplayQuest> quests;
  final int currentIndex;
  final int currentTurnIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final List<DialogueTurn> conversationHistory;

  const DialogueRoleplayLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.currentTurnIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.conversationHistory = const [],
  });

  DialogueRoleplayQuest get currentQuest => quests[currentIndex];
  DialogueTurn get currentTurn => currentQuest.turns![currentTurnIndex];

  DialogueRoleplayLoaded copyWith({
    List<DialogueRoleplayQuest>? quests,
    int? currentIndex,
    int? currentTurnIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    List<DialogueTurn>? conversationHistory,
  }) {
    return DialogueRoleplayLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      currentTurnIndex: currentTurnIndex ?? this.currentTurnIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      conversationHistory: conversationHistory ?? this.conversationHistory,
    );
  }

  @override
  List<Object?> get props => [
        quests,
        currentIndex,
        currentTurnIndex,
        livesRemaining,
        lastAnswerCorrect,
        conversationHistory,
      ];
}

class DialogueRoleplayGameComplete extends DialogueRoleplayState {
  final int xpEarned;
  final int coinsEarned;

  const DialogueRoleplayGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class DialogueRoleplayGameOver extends DialogueRoleplayState {}

class DialogueRoleplayError extends DialogueRoleplayState {
  final String message;

  const DialogueRoleplayError(this.message);

  @override
  List<Object?> get props => [message];
}
