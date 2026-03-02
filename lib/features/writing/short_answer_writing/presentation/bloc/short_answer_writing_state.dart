import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/writing/short_answer_writing/domain/entities/short_answer_writing_quest.dart';

abstract class ShortAnswerWritingState extends Equatable {
  const ShortAnswerWritingState();

  @override
  List<Object?> get props => [];
}

class ShortAnswerWritingInitial extends ShortAnswerWritingState {}

class ShortAnswerWritingLoading extends ShortAnswerWritingState {}

class ShortAnswerWritingLoaded extends ShortAnswerWritingState {
  final List<ShortAnswerWritingQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const ShortAnswerWritingLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  ShortAnswerWritingQuest get currentQuest => quests[currentIndex];

  ShortAnswerWritingLoaded copyWith({
    List<ShortAnswerWritingQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return ShortAnswerWritingLoaded(
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

class ShortAnswerWritingGameComplete extends ShortAnswerWritingState {
  final int xpEarned;
  final int coinsEarned;

  const ShortAnswerWritingGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class ShortAnswerWritingGameOver extends ShortAnswerWritingState {}

class ShortAnswerWritingError extends ShortAnswerWritingState {
  final String message;

  const ShortAnswerWritingError(this.message);

  @override
  List<Object?> get props => [message];
}
