import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/reading/read_and_answer/domain/entities/read_and_answer_quest.dart';

abstract class ReadAndAnswerState extends Equatable {
  const ReadAndAnswerState();

  @override
  List<Object?> get props => [];
}

class ReadAndAnswerInitial extends ReadAndAnswerState {}

class ReadAndAnswerLoading extends ReadAndAnswerState {}

class ReadAndAnswerLoaded extends ReadAndAnswerState {
  final List<ReadAndAnswerQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const ReadAndAnswerLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  ReadAndAnswerQuest get currentQuest => quests[currentIndex];

  ReadAndAnswerLoaded copyWith({
    List<ReadAndAnswerQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return ReadAndAnswerLoaded(
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

class ReadAndAnswerGameComplete extends ReadAndAnswerState {
  final int xpEarned;
  final int coinsEarned;

  const ReadAndAnswerGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class ReadAndAnswerGameOver extends ReadAndAnswerState {}

class ReadAndAnswerError extends ReadAndAnswerState {
  final String message;

  const ReadAndAnswerError(this.message);

  @override
  List<Object?> get props => [message];
}
