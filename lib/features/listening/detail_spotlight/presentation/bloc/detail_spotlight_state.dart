import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/listening/detail_spotlight/domain/entities/detail_spotlight_quest.dart';

abstract class DetailSpotlightState extends Equatable {
  const DetailSpotlightState();

  @override
  List<Object?> get props => [];
}

class DetailSpotlightInitial extends DetailSpotlightState {}

class DetailSpotlightLoading extends DetailSpotlightState {}

class DetailSpotlightLoaded extends DetailSpotlightState {
  final List<DetailSpotlightQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const DetailSpotlightLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  DetailSpotlightQuest get currentQuest => quests[currentIndex];

  DetailSpotlightLoaded copyWith({
    List<DetailSpotlightQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return DetailSpotlightLoaded(
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

class DetailSpotlightGameComplete extends DetailSpotlightState {
  final int xpEarned;
  final int coinsEarned;

  const DetailSpotlightGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class DetailSpotlightGameOver extends DetailSpotlightState {}

class DetailSpotlightError extends DetailSpotlightState {
  final String message;

  const DetailSpotlightError(this.message);

  @override
  List<Object?> get props => [message];
}
