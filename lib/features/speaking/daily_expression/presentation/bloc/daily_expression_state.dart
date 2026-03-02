import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/speaking/daily_expression/domain/entities/daily_expression_quest.dart';

abstract class DailyExpressionState extends Equatable {
  const DailyExpressionState();

  @override
  List<Object?> get props => [];
}

class DailyExpressionInitial extends DailyExpressionState {}

class DailyExpressionLoading extends DailyExpressionState {}

class DailyExpressionLoaded extends DailyExpressionState {
  final List<DailyExpressionQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;

  const DailyExpressionLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
  });

  DailyExpressionQuest get currentQuest => quests[currentIndex];

  DailyExpressionLoaded copyWith({
    List<DailyExpressionQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
  }) {
    return DailyExpressionLoaded(
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

class DailyExpressionGameComplete extends DailyExpressionState {
  final int xpEarned;
  final int coinsEarned;

  const DailyExpressionGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class DailyExpressionGameOver extends DailyExpressionState {}

class DailyExpressionError extends DailyExpressionState {
  final String message;

  const DailyExpressionError(this.message);

  @override
  List<Object?> get props => [message];
}
