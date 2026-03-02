import 'package:equatable/equatable.dart';

abstract class DailyJournalEvent extends Equatable {
  const DailyJournalEvent();

  @override
  List<Object?> get props => [];
}

class FetchDailyJournalQuests extends DailyJournalEvent {
  final int level;

  const FetchDailyJournalQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitDailyJournalAnswer extends DailyJournalEvent {
  final bool isCorrect;

  const SubmitDailyJournalAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextDailyJournalQuestion extends DailyJournalEvent {}

class RestoreDailyJournalLife extends DailyJournalEvent {}

class DailyJournalHintUsed extends DailyJournalEvent {}
