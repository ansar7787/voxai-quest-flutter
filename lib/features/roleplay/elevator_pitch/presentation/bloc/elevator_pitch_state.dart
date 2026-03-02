import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/roleplay/elevator_pitch/domain/entities/elevator_pitch_quest.dart';

abstract class ElevatorPitchState extends Equatable {
  const ElevatorPitchState();

  @override
  List<Object?> get props => [];
}

class ElevatorPitchInitial extends ElevatorPitchState {}

class ElevatorPitchLoading extends ElevatorPitchState {}

class ElevatorPitchLoaded extends ElevatorPitchState {
  final List<ElevatorPitchQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final int xpEarned;
  final int coinsEarned;

  const ElevatorPitchLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.xpEarned = 0,
    this.coinsEarned = 0,
  });

  ElevatorPitchQuest get currentQuest => quests[currentIndex];

  ElevatorPitchLoaded copyWith({
    List<ElevatorPitchQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    int? xpEarned,
    int? coinsEarned,
  }) {
    return ElevatorPitchLoaded(
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

class ElevatorPitchError extends ElevatorPitchState {
  final String message;
  const ElevatorPitchError(this.message);

  @override
  List<Object?> get props => [message];
}

class ElevatorPitchGameComplete extends ElevatorPitchState {
  final int xpEarned;
  final int coinsEarned;
  const ElevatorPitchGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class ElevatorPitchGameOver extends ElevatorPitchState {}
