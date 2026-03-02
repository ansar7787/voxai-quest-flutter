import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/vocabulary/topic_vocab/domain/entities/topic_vocab_quest.dart';

abstract class TopicVocabState extends Equatable {
  const TopicVocabState();

  @override
  List<Object?> get props => [];
}

class TopicVocabInitial extends TopicVocabState {}

class TopicVocabLoading extends TopicVocabState {}

class TopicVocabLoaded extends TopicVocabState {
  final List<TopicVocabQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const TopicVocabLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  TopicVocabQuest get currentQuest => quests[currentIndex];

  TopicVocabLoaded copyWith({
    List<TopicVocabQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return TopicVocabLoaded(
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

class TopicVocabGameComplete extends TopicVocabState {
  final int xpEarned;
  final int coinsEarned;

  const TopicVocabGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class TopicVocabGameOver extends TopicVocabState {}

class TopicVocabError extends TopicVocabState {
  final String message;

  const TopicVocabError(this.message);

  @override
  List<Object?> get props => [message];
}
