import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/vocabulary/flashcards/domain/entities/flashcards_quest.dart';

abstract class FlashcardsState extends Equatable {
  const FlashcardsState();

  @override
  List<Object?> get props => [];
}

class FlashcardsInitial extends FlashcardsState {}

class FlashcardsLoading extends FlashcardsState {}

class FlashcardsLoaded extends FlashcardsState {
  final List<FlashcardsQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const FlashcardsLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  FlashcardsQuest get currentQuest => quests[currentIndex];

  FlashcardsLoaded copyWith({
    List<FlashcardsQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return FlashcardsLoaded(
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

class FlashcardsGameComplete extends FlashcardsState {
  final int xpEarned;
  final int coinsEarned;

  const FlashcardsGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class FlashcardsGameOver extends FlashcardsState {}

class FlashcardsError extends FlashcardsState {
  final String message;

  const FlashcardsError(this.message);

  @override
  List<Object?> get props => [message];
}
