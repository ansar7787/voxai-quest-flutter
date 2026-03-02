import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/roleplay/emergency_hub/domain/entities/emergency_hub_quest.dart';

abstract class EmergencyHubState extends Equatable {
  const EmergencyHubState();

  @override
  List<Object?> get props => [];
}

class EmergencyHubInitial extends EmergencyHubState {}

class EmergencyHubLoading extends EmergencyHubState {}

class EmergencyHubLoaded extends EmergencyHubState {
  final List<EmergencyHubQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final int xpEarned;
  final int coinsEarned;

  const EmergencyHubLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.xpEarned = 0,
    this.coinsEarned = 0,
  });

  EmergencyHubQuest get currentQuest => quests[currentIndex];

  EmergencyHubLoaded copyWith({
    List<EmergencyHubQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    int? xpEarned,
    int? coinsEarned,
  }) {
    return EmergencyHubLoaded(
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

class EmergencyHubError extends EmergencyHubState {
  final String message;
  const EmergencyHubError(this.message);

  @override
  List<Object?> get props => [message];
}

class EmergencyHubGameComplete extends EmergencyHubState {
  final int xpEarned;
  final int coinsEarned;
  const EmergencyHubGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class EmergencyHubGameOver extends EmergencyHubState {}
