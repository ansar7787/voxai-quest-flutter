import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/reading/sentence_order_reading/domain/entities/sentence_order_reading_quest.dart';

abstract class SentenceOrderReadingState extends Equatable {
  const SentenceOrderReadingState();

  @override
  List<Object?> get props => [];
}

class SentenceOrderReadingInitial extends SentenceOrderReadingState {}

class SentenceOrderReadingLoading extends SentenceOrderReadingState {}

class SentenceOrderReadingLoaded extends SentenceOrderReadingState {
  final List<SentenceOrderReadingQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const SentenceOrderReadingLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  SentenceOrderReadingQuest get currentQuest => quests[currentIndex];

  SentenceOrderReadingLoaded copyWith({
    List<SentenceOrderReadingQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return SentenceOrderReadingLoaded(
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

class SentenceOrderReadingGameComplete extends SentenceOrderReadingState {
  final int xpEarned;
  final int coinsEarned;

  const SentenceOrderReadingGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class SentenceOrderReadingGameOver extends SentenceOrderReadingState {}

class SentenceOrderReadingError extends SentenceOrderReadingState {
  final String message;

  const SentenceOrderReadingError(this.message);

  @override
  List<Object?> get props => [message];
}
