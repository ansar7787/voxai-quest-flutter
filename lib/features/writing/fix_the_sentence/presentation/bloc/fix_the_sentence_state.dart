import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/writing/fix_the_sentence/domain/entities/fix_the_sentence_quest.dart';

abstract class FixTheSentenceState extends Equatable {
  const FixTheSentenceState();

  @override
  List<Object?> get props => [];
}

class FixTheSentenceInitial extends FixTheSentenceState {}

class FixTheSentenceLoading extends FixTheSentenceState {}

class FixTheSentenceLoaded extends FixTheSentenceState {
  final List<FixTheSentenceQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const FixTheSentenceLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  FixTheSentenceQuest get currentQuest => quests[currentIndex];

  FixTheSentenceLoaded copyWith({
    List<FixTheSentenceQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return FixTheSentenceLoaded(
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

class FixTheSentenceGameComplete extends FixTheSentenceState {
  final int xpEarned;
  final int coinsEarned;

  const FixTheSentenceGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class FixTheSentenceGameOver extends FixTheSentenceState {}

class FixTheSentenceError extends FixTheSentenceState {
  final String message;

  const FixTheSentenceError(this.message);

  @override
  List<Object?> get props => [message];
}
