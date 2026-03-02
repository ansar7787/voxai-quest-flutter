import 'package:equatable/equatable.dart';

abstract class SummarizeStoryWritingEvent extends Equatable {
  const SummarizeStoryWritingEvent();

  @override
  List<Object?> get props => [];
}

class FetchSummarizeStoryWritingQuests extends SummarizeStoryWritingEvent {
  final int level;

  const FetchSummarizeStoryWritingQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitSummarizeStoryWritingAnswer extends SummarizeStoryWritingEvent {
  final bool isCorrect;

  const SubmitSummarizeStoryWritingAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextSummarizeStoryWritingQuestion extends SummarizeStoryWritingEvent {}

class RestoreSummarizeStoryWritingLife extends SummarizeStoryWritingEvent {}

class SummarizeStoryWritingHintUsed extends SummarizeStoryWritingEvent {}
