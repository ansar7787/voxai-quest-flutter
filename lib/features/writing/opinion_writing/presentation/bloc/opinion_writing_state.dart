import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/writing/opinion_writing/domain/entities/opinion_writing_quest.dart';

abstract class OpinionWritingState extends Equatable {
  const OpinionWritingState();

  @override
  List<Object?> get props => [];
}

class OpinionWritingInitial extends OpinionWritingState {}

class OpinionWritingLoading extends OpinionWritingState {}

class OpinionWritingLoaded extends OpinionWritingState {
  final List<OpinionWritingQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const OpinionWritingLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  OpinionWritingQuest get currentQuest => quests[currentIndex];

  OpinionWritingLoaded copyWith({
    List<OpinionWritingQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return OpinionWritingLoaded(
      quests: quests ?? this.quests,
      currentIndex: currentIndex ?? this.currentIndex,
      livesRemaining: livesRemaining ?? this.livesRemaining,
      lastAnswerCorrect: lastAnswerCorrect,
      hintUsed: hintUsed ?? this.hintUsed,
    );
  }

  @override
  List<Object?> get props => [
    quests,
    currentIndex,
    livesRemaining,
    lastAnswerCorrect,
    hintUsed,
  ];
}

class OpinionWritingGameComplete extends OpinionWritingState {
  final int xpEarned;
  final int coinsEarned;

  const OpinionWritingGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class OpinionWritingGameOver extends OpinionWritingState {}

class OpinionWritingError extends OpinionWritingState {
  final String message;

  const OpinionWritingError(this.message);

  @override
  List<Object?> get props => [message];
}
