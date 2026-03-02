import 'package:equatable/equatable.dart';

abstract class ParagraphSummaryEvent extends Equatable {
  const ParagraphSummaryEvent();

  @override
  List<Object?> get props => [];
}

class FetchParagraphSummaryQuests extends ParagraphSummaryEvent {
  final int level;

  const FetchParagraphSummaryQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitParagraphSummaryAnswer extends ParagraphSummaryEvent {
  final bool isCorrect;

  const SubmitParagraphSummaryAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextParagraphSummaryQuestion extends ParagraphSummaryEvent {}

class RestoreParagraphSummaryLife extends ParagraphSummaryEvent {}

class ParagraphSummaryHintUsed extends ParagraphSummaryEvent {}
