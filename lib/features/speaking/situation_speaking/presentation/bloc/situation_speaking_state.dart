import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/speaking/situation_speaking/domain/entities/situation_speaking_quest.dart';

abstract class SituationSpeakingState extends Equatable {
  const SituationSpeakingState();

  @override
  List<Object?> get props => [];
}

class SituationSpeakingInitial extends SituationSpeakingState {}

class SituationSpeakingLoading extends SituationSpeakingState {}

class SituationSpeakingLoaded extends SituationSpeakingState {
  final List<SituationSpeakingQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const SituationSpeakingLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  SituationSpeakingQuest get currentQuest => quests[currentIndex];

  SituationSpeakingLoaded copyWith({
    List<SituationSpeakingQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return SituationSpeakingLoaded(
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

class SituationSpeakingGameComplete extends SituationSpeakingState {
  final int xpEarned;
  final int coinsEarned;

  const SituationSpeakingGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class SituationSpeakingGameOver extends SituationSpeakingState {}

class SituationSpeakingError extends SituationSpeakingState {
  final String message;

  const SituationSpeakingError(this.message);

  @override
  List<Object?> get props => [message];
}
