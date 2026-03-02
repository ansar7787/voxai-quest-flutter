import 'package:equatable/equatable.dart';

abstract class DailyExpressionEvent extends Equatable {
  const DailyExpressionEvent();

  @override
  List<Object?> get props => [];
}

class FetchDailyExpressionQuests extends DailyExpressionEvent {
  final int level;

  const FetchDailyExpressionQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitDailyExpressionAnswer extends DailyExpressionEvent {
  final bool isCorrect;

  const SubmitDailyExpressionAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextDailyExpressionQuestion extends DailyExpressionEvent {}

class RestoreDailyExpressionLife extends DailyExpressionEvent {}
