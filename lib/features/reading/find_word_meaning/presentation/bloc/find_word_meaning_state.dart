import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/reading/find_word_meaning/domain/entities/find_word_meaning_quest.dart';

abstract class FindWordMeaningState extends Equatable {
  const FindWordMeaningState();

  @override
  List<Object?> get props => [];
}

class FindWordMeaningInitial extends FindWordMeaningState {}

class FindWordMeaningLoading extends FindWordMeaningState {}

class FindWordMeaningLoaded extends FindWordMeaningState {
  final List<FindWordMeaningQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const FindWordMeaningLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  FindWordMeaningQuest get currentQuest => quests[currentIndex];

  FindWordMeaningLoaded copyWith({
    List<FindWordMeaningQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return FindWordMeaningLoaded(
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

class FindWordMeaningGameComplete extends FindWordMeaningState {
  final int xpEarned;
  final int coinsEarned;

  const FindWordMeaningGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class FindWordMeaningGameOver extends FindWordMeaningState {}

class FindWordMeaningError extends FindWordMeaningState {
  final String message;

  const FindWordMeaningError(this.message);

  @override
  List<Object?> get props => [message];
}
