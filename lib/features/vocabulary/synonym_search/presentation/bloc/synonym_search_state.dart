import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/vocabulary/synonym_search/domain/entities/synonym_search_quest.dart';

abstract class SynonymSearchState extends Equatable {
  const SynonymSearchState();

  @override
  List<Object?> get props => [];
}

class SynonymSearchInitial extends SynonymSearchState {}

class SynonymSearchLoading extends SynonymSearchState {}

class SynonymSearchLoaded extends SynonymSearchState {
  final List<SynonymSearchQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const SynonymSearchLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  SynonymSearchQuest get currentQuest => quests[currentIndex];

  SynonymSearchLoaded copyWith({
    List<SynonymSearchQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return SynonymSearchLoaded(
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

class SynonymSearchGameComplete extends SynonymSearchState {
  final int xpEarned;
  final int coinsEarned;

  const SynonymSearchGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class SynonymSearchGameOver extends SynonymSearchState {}

class SynonymSearchError extends SynonymSearchState {
  final String message;

  const SynonymSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
