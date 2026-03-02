import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/vocabulary/antonym_search/domain/entities/antonym_search_quest.dart';

abstract class AntonymSearchState extends Equatable {
  const AntonymSearchState();

  @override
  List<Object?> get props => [];
}

class AntonymSearchInitial extends AntonymSearchState {}

class AntonymSearchLoading extends AntonymSearchState {}

class AntonymSearchLoaded extends AntonymSearchState {
  final List<AntonymSearchQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const AntonymSearchLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  AntonymSearchQuest get currentQuest => quests[currentIndex];

  AntonymSearchLoaded copyWith({
    List<AntonymSearchQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return AntonymSearchLoaded(
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

class AntonymSearchGameComplete extends AntonymSearchState {
  final int xpEarned;
  final int coinsEarned;

  const AntonymSearchGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class AntonymSearchGameOver extends AntonymSearchState {}

class AntonymSearchError extends AntonymSearchState {
  final String message;

  const AntonymSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
