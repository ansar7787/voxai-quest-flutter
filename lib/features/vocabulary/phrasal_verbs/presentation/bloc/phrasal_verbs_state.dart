import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/vocabulary/phrasal_verbs/domain/entities/phrasal_verbs_quest.dart';

abstract class PhrasalVerbsState extends Equatable {
  const PhrasalVerbsState();

  @override
  List<Object?> get props => [];
}

class PhrasalVerbsInitial extends PhrasalVerbsState {}

class PhrasalVerbsLoading extends PhrasalVerbsState {}

class PhrasalVerbsLoaded extends PhrasalVerbsState {
  final List<PhrasalVerbsQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const PhrasalVerbsLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  PhrasalVerbsQuest get currentQuest => quests[currentIndex];

  PhrasalVerbsLoaded copyWith({
    List<PhrasalVerbsQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return PhrasalVerbsLoaded(
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

class PhrasalVerbsGameComplete extends PhrasalVerbsState {
  final int xpEarned;
  final int coinsEarned;

  const PhrasalVerbsGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class PhrasalVerbsGameOver extends PhrasalVerbsState {}

class PhrasalVerbsError extends PhrasalVerbsState {
  final String message;

  const PhrasalVerbsError(this.message);

  @override
  List<Object?> get props => [message];
}
