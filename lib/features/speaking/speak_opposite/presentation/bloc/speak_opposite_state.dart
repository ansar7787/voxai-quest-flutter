import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/speaking/speak_opposite/domain/entities/speak_opposite_quest.dart';

abstract class SpeakOppositeState extends Equatable {
  const SpeakOppositeState();

  @override
  List<Object?> get props => [];
}

class SpeakOppositeInitial extends SpeakOppositeState {}

class SpeakOppositeLoading extends SpeakOppositeState {}

class SpeakOppositeLoaded extends SpeakOppositeState {
  final List<SpeakOppositeQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const SpeakOppositeLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  SpeakOppositeQuest get currentQuest => quests[currentIndex];

  SpeakOppositeLoaded copyWith({
    List<SpeakOppositeQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return SpeakOppositeLoaded(
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

class SpeakOppositeGameComplete extends SpeakOppositeState {
  final int xpEarned;
  final int coinsEarned;

  const SpeakOppositeGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class SpeakOppositeGameOver extends SpeakOppositeState {}

class SpeakOppositeError extends SpeakOppositeState {
  final String message;

  const SpeakOppositeError(this.message);

  @override
  List<Object?> get props => [message];
}
