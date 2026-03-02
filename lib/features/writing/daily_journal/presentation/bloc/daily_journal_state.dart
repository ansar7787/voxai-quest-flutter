import 'package:equatable/equatable.dart';
import 'package:voxai_quest/features/writing/daily_journal/domain/entities/daily_journal_quest.dart';

abstract class DailyJournalState extends Equatable {
  const DailyJournalState();

  @override
  List<Object?> get props => [];
}

class DailyJournalInitial extends DailyJournalState {}

class DailyJournalLoading extends DailyJournalState {}

class DailyJournalLoaded extends DailyJournalState {
  final List<DailyJournalQuest> quests;
  final int currentIndex;
  final int livesRemaining;
  final bool? lastAnswerCorrect;
  final bool hintUsed;

  const DailyJournalLoaded({
    required this.quests,
    this.currentIndex = 0,
    this.livesRemaining = 3,
    this.lastAnswerCorrect,
    this.hintUsed = false,
  });

  DailyJournalQuest get currentQuest => quests[currentIndex];

  DailyJournalLoaded copyWith({
    List<DailyJournalQuest>? quests,
    int? currentIndex,
    int? livesRemaining,
    bool? lastAnswerCorrect,
    bool? hintUsed,
  }) {
    return DailyJournalLoaded(
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

class DailyJournalGameComplete extends DailyJournalState {
  final int xpEarned;
  final int coinsEarned;

  const DailyJournalGameComplete({
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  List<Object?> get props => [xpEarned, coinsEarned];
}

class DailyJournalGameOver extends DailyJournalState {}

class DailyJournalError extends DailyJournalState {
  final String message;

  const DailyJournalError(this.message);

  @override
  List<Object?> get props => [message];
}
