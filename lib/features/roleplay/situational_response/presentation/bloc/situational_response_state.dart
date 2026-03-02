import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/roleplay/situational_response/domain/entities/situational_response_quest.dart';

abstract class SituationalResponseState extends Equatable {
  const SituationalResponseState();

  @override
  List<Object?> get props => [];
}

class SituationalResponseInitial extends SituationalResponseState {}

class SituationalResponseLoading extends SituationalResponseState {}

class SituationalResponseLoaded extends SituationalResponseState {
  final List<SituationalResponseQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final int xpEarned;
  final int coinsEarned;

  const SituationalResponseLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.xpEarned = 0,
    this.coinsEarned = 0,
  });

  SituationalResponseQuest get currentQuest => quests[currentIndex];

  SituationalResponseLoaded copyWith({
    List<SituationalResponseQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    int? xpEarned,
    int? coinsEarned,
  }) {
    return SituationalResponseLoaded(
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

class SituationalResponseError extends SituationalResponseState {
  final String message;
  const SituationalResponseError(this.message);

  @override
  List<Object?> get props => [message];
}

class SituationalResponseGameComplete extends SituationalResponseState {
  final int xpEarned;
  final int coinsEarned;
  const SituationalResponseGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class SituationalResponseGameOver extends SituationalResponseState {}
