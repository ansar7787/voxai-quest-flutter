import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/roleplay/social_spark/domain/entities/social_spark_quest.dart';

abstract class SocialSparkState extends Equatable {
  const SocialSparkState();

  @override
  List<Object?> get props => [];
}

class SocialSparkInitial extends SocialSparkState {}

class SocialSparkLoading extends SocialSparkState {}

class SocialSparkLoaded extends SocialSparkState {
  final List<SocialSparkQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final int xpEarned;
  final int coinsEarned;

  const SocialSparkLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.xpEarned = 0,
    this.coinsEarned = 0,
  });

  SocialSparkQuest get currentQuest => quests[currentIndex];

  SocialSparkLoaded copyWith({
    List<SocialSparkQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    int? xpEarned,
    int? coinsEarned,
  }) {
    return SocialSparkLoaded(
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

class SocialSparkError extends SocialSparkState {
  final String message;
  const SocialSparkError(this.message);

  @override
  List<Object?> get props => [message];
}

class SocialSparkGameComplete extends SocialSparkState {
  final int xpEarned;
  final int coinsEarned;
  const SocialSparkGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class SocialSparkGameOver extends SocialSparkState {}
