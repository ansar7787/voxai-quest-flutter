import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/writing/essay_drafting/domain/entities/essay_drafting_quest.dart';

abstract class EssayDraftingState extends Equatable {
  const EssayDraftingState();

  @override
  List<Object?> get props => [];
}

class EssayDraftingInitial extends EssayDraftingState {}

class EssayDraftingLoading extends EssayDraftingState {}

class EssayDraftingLoaded extends EssayDraftingState {
  final List<EssayDraftingQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const EssayDraftingLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  EssayDraftingQuest get currentQuest => quests[currentIndex];

  EssayDraftingLoaded copyWith({
    List<EssayDraftingQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return EssayDraftingLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      hintUsed: hintUsed ?? this.hintUsed,
    );
  }

  @override
  List<Object?> get props => [
    quests,
    currentIndex,
    livesRemaining,
    lastAnswerCorrect,
    hintUsed,
  ];
}

class EssayDraftingGameComplete extends EssayDraftingState {
  final int xpEarned;
  final int coinsEarned;

  const EssayDraftingGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class EssayDraftingGameOver extends EssayDraftingState {}

class EssayDraftingError extends EssayDraftingState {
  final String message;

  const EssayDraftingError(this.message);

  @override
  List<Object?> get props => [message];
}
