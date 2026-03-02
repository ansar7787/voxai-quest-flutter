import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/roleplay/travel_desk/domain/entities/travel_desk_quest.dart';

abstract class TravelDeskState extends Equatable {
  const TravelDeskState();

  @override
  List<Object?> get props => [];
}

class TravelDeskInitial extends TravelDeskState {}

class TravelDeskLoading extends TravelDeskState {}

class TravelDeskLoaded extends TravelDeskState {
  final List<TravelDeskQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final int xpEarned;
  final int coinsEarned;

  const TravelDeskLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.xpEarned = 0,
    this.coinsEarned = 0,
  });

  TravelDeskQuest get currentQuest => quests[currentIndex];

  TravelDeskLoaded copyWith({
    List<TravelDeskQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    int? xpEarned,
    int? coinsEarned,
  }) {
    return TravelDeskLoaded(
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

class TravelDeskError extends TravelDeskState {
  final String message;
  const TravelDeskError(this.message);

  @override
  List<Object?> get props => [message];
}

class TravelDeskGameComplete extends TravelDeskState {
  final int xpEarned;
  final int coinsEarned;
  const TravelDeskGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class TravelDeskGameOver extends TravelDeskState {}
