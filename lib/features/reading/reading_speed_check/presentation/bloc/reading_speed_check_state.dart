import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/reading/reading_speed_check/domain/entities/reading_speed_check_quest.dart';

abstract class ReadingSpeedCheckState extends Equatable {
  const ReadingSpeedCheckState();

  @override
  List<Object?> get props => [];
}

class ReadingSpeedCheckInitial extends ReadingSpeedCheckState {}

class ReadingSpeedCheckLoading extends ReadingSpeedCheckState {}

class ReadingSpeedCheckLoaded extends ReadingSpeedCheckState {
  final List<ReadingSpeedCheckQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const ReadingSpeedCheckLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  ReadingSpeedCheckQuest get currentQuest => quests[currentIndex];

  ReadingSpeedCheckLoaded copyWith({
    List<ReadingSpeedCheckQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return ReadingSpeedCheckLoaded(
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

class ReadingSpeedCheckGameComplete extends ReadingSpeedCheckState {
  final int xpEarned;
  final int coinsEarned;

  const ReadingSpeedCheckGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class ReadingSpeedCheckGameOver extends ReadingSpeedCheckState {}

class ReadingSpeedCheckError extends ReadingSpeedCheckState {
  final String message;

  const ReadingSpeedCheckError(this.message);

  @override
  List<Object?> get props => [message];
}
