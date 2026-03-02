import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/reading/true_false_reading/domain/entities/true_false_reading_quest.dart';

abstract class TrueFalseReadingState extends Equatable {
  const TrueFalseReadingState();

  @override
  List<Object?> get props => [];
}

class TrueFalseReadingInitial extends TrueFalseReadingState {}

class TrueFalseReadingLoading extends TrueFalseReadingState {}

class TrueFalseReadingLoaded extends TrueFalseReadingState {
  final List<TrueFalseReadingQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const TrueFalseReadingLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  TrueFalseReadingQuest get currentQuest => quests[currentIndex];

  TrueFalseReadingLoaded copyWith({
    List<TrueFalseReadingQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return TrueFalseReadingLoaded(
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

class TrueFalseReadingGameComplete extends TrueFalseReadingState {
  final int xpEarned;
  final int coinsEarned;

  const TrueFalseReadingGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class TrueFalseReadingGameOver extends TrueFalseReadingState {}

class TrueFalseReadingError extends TrueFalseReadingState {
  final String message;

  const TrueFalseReadingError(this.message);

  @override
  List<Object?> get props => [message];
}
