import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/vocabulary/context_clues/domain/entities/context_clues_quest.dart';

abstract class ContextCluesState extends Equatable {
  const ContextCluesState();

  @override
  List<Object?> get props => [];
}

class ContextCluesInitial extends ContextCluesState {}

class ContextCluesLoading extends ContextCluesState {}

class ContextCluesLoaded extends ContextCluesState {
  final List<ContextCluesQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const ContextCluesLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  ContextCluesQuest get currentQuest => quests[currentIndex];

  ContextCluesLoaded copyWith({
    List<ContextCluesQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return ContextCluesLoaded(
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

class ContextCluesGameComplete extends ContextCluesState {
  final int xpEarned;
  final int coinsEarned;

  const ContextCluesGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class ContextCluesGameOver extends ContextCluesState {}

class ContextCluesError extends ContextCluesState {
  final String message;

  const ContextCluesError(this.message);

  @override
  List<Object?> get props => [message];
}
