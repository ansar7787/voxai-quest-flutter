import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/vocabulary/word_formation/domain/entities/word_formation_quest.dart';

abstract class WordFormationState extends Equatable {
  const WordFormationState();

  @override
  List<Object?> get props => [];
}

class WordFormationInitial extends WordFormationState {}

class WordFormationLoading extends WordFormationState {}

class WordFormationLoaded extends WordFormationState {
  final List<WordFormationQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const WordFormationLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  WordFormationQuest get currentQuest => quests[currentIndex];

  WordFormationLoaded copyWith({
    List<WordFormationQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return WordFormationLoaded(
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

class WordFormationGameComplete extends WordFormationState {
  final int xpEarned;
  final int coinsEarned;

  const WordFormationGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class WordFormationGameOver extends WordFormationState {}

class WordFormationError extends WordFormationState {
  final String message;

  const WordFormationError(this.message);

  @override
  List<Object?> get props => [message];
}
