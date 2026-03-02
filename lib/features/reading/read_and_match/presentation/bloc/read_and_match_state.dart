import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/reading/read_and_match/domain/entities/read_and_match_quest.dart';

abstract class ReadAndMatchState extends Equatable {
  const ReadAndMatchState();

  @override
  List<Object?> get props => [];
}

class ReadAndMatchInitial extends ReadAndMatchState {}

class ReadAndMatchLoading extends ReadAndMatchState {}

class ReadAndMatchLoaded extends ReadAndMatchState {
  final List<ReadAndMatchQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const ReadAndMatchLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  ReadAndMatchQuest get currentQuest => quests[currentIndex];

  ReadAndMatchLoaded copyWith({
    List<ReadAndMatchQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return ReadAndMatchLoaded(
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

class ReadAndMatchGameComplete extends ReadAndMatchState {
  final int xpEarned;
  final int coinsEarned;

  const ReadAndMatchGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class ReadAndMatchGameOver extends ReadAndMatchState {}

class ReadAndMatchError extends ReadAndMatchState {
  final String message;

  const ReadAndMatchError(this.message);

  @override
  List<Object?> get props => [message];
}
