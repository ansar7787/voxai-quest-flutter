import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/roleplay/branching_dialogue/domain/entities/branching_dialogue_quest.dart';

abstract class BranchingDialogueState extends Equatable {
  const BranchingDialogueState();

  @override
  List<Object?> get props => [];
}

class BranchingDialogueInitial extends BranchingDialogueState {}

class BranchingDialogueLoading extends BranchingDialogueState {}

class BranchingDialogueLoaded extends BranchingDialogueState {
  final List<BranchingDialogueQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final int xpEarned;
  final int coinsEarned;

  const BranchingDialogueLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.xpEarned = 0,
    this.coinsEarned = 0,
  });

  BranchingDialogueQuest get currentQuest => quests[currentIndex];

  BranchingDialogueLoaded copyWith({
    List<BranchingDialogueQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    int? xpEarned,
    int? coinsEarned,
  }) {
    return BranchingDialogueLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      xpEarned: xpEarned ?? this.xpEarned,
      coinsEarned: coinsEarned ?? this.coinsEarned,
    );
  }

  @override
  List<Object?> get props => [
        quests,
        currentIndex,
        livesRemaining,
        lastAnswerCorrect,
        xpEarned,
        coinsEarned,
      ];
}

class BranchingDialogueError extends BranchingDialogueState {
  final String message;
  const BranchingDialogueError(this.message);

  @override
  List<Object?> get props => [message];
}

class BranchingDialogueGameComplete extends BranchingDialogueState {
  final int xpEarned;
  final int coinsEarned;
  const BranchingDialogueGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class BranchingDialogueGameOver extends BranchingDialogueState {}
