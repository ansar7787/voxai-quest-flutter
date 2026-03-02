import 'package:equatable/equatable.dart';

abstract class FindWordMeaningEvent extends Equatable {
  const FindWordMeaningEvent();

  @override
  List<Object?> get props => [];
}

class FetchFindWordMeaningQuests extends FindWordMeaningEvent {
  final int level;

  const FetchFindWordMeaningQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitFindWordMeaningAnswer extends FindWordMeaningEvent {
  final bool isCorrect;

  const SubmitFindWordMeaningAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextFindWordMeaningQuestion extends FindWordMeaningEvent {}

class RestoreFindWordMeaningLife extends FindWordMeaningEvent {}

class FindWordMeaningHintUsed extends FindWordMeaningEvent {}
