import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/writing/describe_situation_writing/domain/entities/describe_situation_writing_quest.dart';

abstract class DescribeSituationWritingState extends Equatable {
  const DescribeSituationWritingState();

  @override
  List<Object?> get props => [];
}

class DescribeSituationWritingInitial extends DescribeSituationWritingState {}

class DescribeSituationWritingLoading extends DescribeSituationWritingState {}

class DescribeSituationWritingLoaded extends DescribeSituationWritingState {
  final List<DescribeSituationWritingQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const DescribeSituationWritingLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  DescribeSituationWritingQuest get currentQuest => quests[currentIndex];

  DescribeSituationWritingLoaded copyWith({
    List<DescribeSituationWritingQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return DescribeSituationWritingLoaded(
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

class DescribeSituationWritingGameComplete
    extends DescribeSituationWritingState {
  final int xpEarned;
  final int coinsEarned;

  const DescribeSituationWritingGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class DescribeSituationWritingGameOver extends DescribeSituationWritingState {}

class DescribeSituationWritingError extends DescribeSituationWritingState {
  final String message;

  const DescribeSituationWritingError(this.message);

  @override
  List<Object?> get props => [message];
}
