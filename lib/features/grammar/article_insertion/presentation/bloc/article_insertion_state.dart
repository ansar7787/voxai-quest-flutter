import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/grammar/article_insertion/domain/entities/article_insertion_quest.dart';

abstract class ArticleInsertionState extends Equatable {
  const ArticleInsertionState();

  @override
  List<Object?> get props => [];
}

class ArticleInsertionInitial extends ArticleInsertionState {}

class ArticleInsertionLoading extends ArticleInsertionState {}

class ArticleInsertionLoaded extends ArticleInsertionState {
  final List<ArticleInsertionQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const ArticleInsertionLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  ArticleInsertionQuest get currentQuest => quests[currentIndex];

  ArticleInsertionLoaded copyWith({
    List<ArticleInsertionQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return ArticleInsertionLoaded(
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

class ArticleInsertionGameComplete extends ArticleInsertionState {
  final int xpEarned;
  final int coinsEarned;

  const ArticleInsertionGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class ArticleInsertionGameOver extends ArticleInsertionState {}

class ArticleInsertionError extends ArticleInsertionState {
  final String message;

  const ArticleInsertionError(this.message);

  @override
  List<Object?> get props => [message];
}
