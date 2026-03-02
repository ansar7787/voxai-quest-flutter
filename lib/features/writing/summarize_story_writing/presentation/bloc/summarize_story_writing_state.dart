import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/writing/summarize_story_writing/domain/entities/summarize_story_writing_quest.dart';

abstract class SummarizeStoryWritingState extends Equatable {
  const SummarizeStoryWritingState();

  @override
  List<Object?> get props => [];
}

class SummarizeStoryWritingInitial extends SummarizeStoryWritingState {}

class SummarizeStoryWritingLoading extends SummarizeStoryWritingState {}

class SummarizeStoryWritingLoaded extends SummarizeStoryWritingState {
  final List<SummarizeStoryWritingQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const SummarizeStoryWritingLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  SummarizeStoryWritingQuest get currentQuest => quests[currentIndex];

  SummarizeStoryWritingLoaded copyWith({
    List<SummarizeStoryWritingQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return SummarizeStoryWritingLoaded(
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

class SummarizeStoryWritingGameComplete extends SummarizeStoryWritingState {
  final int xpEarned;
  final int coinsEarned;

  const SummarizeStoryWritingGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class SummarizeStoryWritingGameOver extends SummarizeStoryWritingState {}

class SummarizeStoryWritingError extends SummarizeStoryWritingState {
  final String message;

  const SummarizeStoryWritingError(this.message);

  @override
  List<Object?> get props => [message];
}
