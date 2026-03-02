import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/grammar/tense_mastery/domain/entities/tense_mastery_quest.dart';

abstract class TenseMasteryState extends Equatable {
  const TenseMasteryState();

  @override
  List<Object?> get props => [];
}

class TenseMasteryInitial extends TenseMasteryState {}

class TenseMasteryLoading extends TenseMasteryState {}

class TenseMasteryLoaded extends TenseMasteryState {
  final List<TenseMasteryQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const TenseMasteryLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  TenseMasteryQuest get currentQuest => quests[currentIndex];

  TenseMasteryLoaded copyWith({
    List<TenseMasteryQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return TenseMasteryLoaded(
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

class TenseMasteryGameComplete extends TenseMasteryState {
  final int xpEarned;
  final int coinsEarned;

  const TenseMasteryGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class TenseMasteryGameOver extends TenseMasteryState {}

class TenseMasteryError extends TenseMasteryState {
  final String message;

  const TenseMasteryError(this.message);

  @override
  List<Object?> get props => [message];
}
