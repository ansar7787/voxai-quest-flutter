import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/reading/paragraph_summary/domain/entities/paragraph_summary_quest.dart';

abstract class ParagraphSummaryState extends Equatable {
  const ParagraphSummaryState();

  @override
  List<Object?> get props => [];
}

class ParagraphSummaryInitial extends ParagraphSummaryState {}

class ParagraphSummaryLoading extends ParagraphSummaryState {}

class ParagraphSummaryLoaded extends ParagraphSummaryState {
  final List<ParagraphSummaryQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const ParagraphSummaryLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  ParagraphSummaryQuest get currentQuest => quests[currentIndex];

  ParagraphSummaryLoaded copyWith({
    List<ParagraphSummaryQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return ParagraphSummaryLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      hintUsed: hintUsed ?? this.hintUsed,
    );
  }

  @override
  List<Object?> get props => [quests, currentIndex, livesRemaining, lastAnswerCorrect, hintUsed];
}

class ParagraphSummaryGameComplete extends ParagraphSummaryState {
  final int xpEarned;
  final int coinsEarned;

  const ParagraphSummaryGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class ParagraphSummaryGameOver extends ParagraphSummaryState {}

class ParagraphSummaryError extends ParagraphSummaryState {
  final String message;

  const ParagraphSummaryError(this.message);

  @override
  List<Object?> get props => [message];
}
