import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/grammar/question_formatter/domain/entities/question_formatter_quest.dart';

abstract class QuestionFormatterState extends Equatable {
  const QuestionFormatterState();

  @override
  List<Object?> get props => [];
}

class QuestionFormatterInitial extends QuestionFormatterState {}

class QuestionFormatterLoading extends QuestionFormatterState {}

class QuestionFormatterLoaded extends QuestionFormatterState {
  final List<QuestionFormatterQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const QuestionFormatterLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  QuestionFormatterQuest get currentQuest => quests[currentIndex];

  QuestionFormatterLoaded copyWith({
    List<QuestionFormatterQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return QuestionFormatterLoaded(
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

class QuestionFormatterGameComplete extends QuestionFormatterState {
  final int xpEarned;
  final int coinsEarned;

  const QuestionFormatterGameComplete({required this.xpEarned, required this.coinsEarned});

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class QuestionFormatterGameOver extends QuestionFormatterState {}

class QuestionFormatterError extends QuestionFormatterState {
  final String message;

  const QuestionFormatterError(this.message);

  @override
  List<Object?> get props => [message];
}
