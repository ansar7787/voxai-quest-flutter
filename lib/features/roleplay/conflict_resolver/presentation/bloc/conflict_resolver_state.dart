import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/roleplay/conflict_resolver/domain/entities/conflict_resolver_quest.dart';

abstract class ConflictResolverState extends Equatable {
  const ConflictResolverState();

  @override
  List<Object?> get props => [];
}

class ConflictResolverInitial extends ConflictResolverState {}

class ConflictResolverLoading extends ConflictResolverState {}

class ConflictResolverLoaded extends ConflictResolverState {
  final List<ConflictResolverQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final int xpEarned;
  final int coinsEarned;

  const ConflictResolverLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.xpEarned = 0,
    this.coinsEarned = 0,
  });

  ConflictResolverQuest get currentQuest => quests[currentIndex];

  ConflictResolverLoaded copyWith({
    List<ConflictResolverQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    int? xpEarned,
    int? coinsEarned,
  }) {
    return ConflictResolverLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      xpEarned: xpEarned ?? this.xpEarned,
      coinsEarned: coinsEarned ?? this.coinsEarned,
    );
  }

  @override
  List<Object?> get props => [
        quests,
        currentIndex,
        livesRemaining,
        lastAnswerCorrect,
        xpEarned,
        coinsEarned,
      ];
}

class ConflictResolverError extends ConflictResolverState {
  final String message;
  const ConflictResolverError(this.message);

  @override
  List<Object?> get props => [message];
}

class ConflictResolverGameComplete extends ConflictResolverState {
  final int xpEarned;
  final int coinsEarned;
  const ConflictResolverGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class ConflictResolverGameOver extends ConflictResolverState {}
