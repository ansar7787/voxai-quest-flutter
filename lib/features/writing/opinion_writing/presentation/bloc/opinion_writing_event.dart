import 'package:equatable/equatable.dart';

abstract class OpinionWritingEvent extends Equatable {
  const OpinionWritingEvent();

  @override
  List<Object?> get props => [];
}

class FetchOpinionWritingQuests extends OpinionWritingEvent {
  final int level;

  const FetchOpinionWritingQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitOpinionWritingAnswer extends OpinionWritingEvent {
  final bool isCorrect;

  const SubmitOpinionWritingAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextOpinionWritingQuestion extends OpinionWritingEvent {}

class RestoreOpinionWritingLife extends OpinionWritingEvent {}

class OpinionWritingHintUsed extends OpinionWritingEvent {}
