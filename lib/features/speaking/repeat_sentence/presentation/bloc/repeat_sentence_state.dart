import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/speaking/repeat_sentence/domain/entities/repeat_sentence_quest.dart';

abstract class RepeatSentenceState extends Equatable {
  const RepeatSentenceState();

  @override
  List<Object?> get props => [];
}

class RepeatSentenceInitial extends RepeatSentenceState {}

class RepeatSentenceLoading extends RepeatSentenceState {}

class RepeatSentenceLoaded extends RepeatSentenceState {
  final List<RepeatSentenceQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const RepeatSentenceLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  RepeatSentenceQuest get currentQuest => quests[currentIndex];

  RepeatSentenceLoaded copyWith({
    List<RepeatSentenceQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return RepeatSentenceLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
    );
  }

  @override
  List<Object?> get props => [
    quests,
    currentIndex,
    livesRemaining,
    lastAnswerCorrect,
  ];
}

class RepeatSentenceGameComplete extends RepeatSentenceState {
  final int xpEarned;
  final int coinsEarned;

  const RepeatSentenceGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class RepeatSentenceGameOver extends RepeatSentenceState {}

class RepeatSentenceError extends RepeatSentenceState {
  final String message;

  const RepeatSentenceError(this.message);

  @override
  List<Object?> get props => [message];
}
