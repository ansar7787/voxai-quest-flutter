import 'package:equatable/equatable.dart';

abstract class ShortAnswerWritingEvent extends Equatable {
  const ShortAnswerWritingEvent();

  @override
  List<Object?> get props => [];
}

class FetchShortAnswerWritingQuests extends ShortAnswerWritingEvent {
  final int level;

  const FetchShortAnswerWritingQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitShortAnswerWritingAnswer extends ShortAnswerWritingEvent {
  final bool isCorrect;

  const SubmitShortAnswerWritingAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextShortAnswerWritingQuestion extends ShortAnswerWritingEvent {}

class RestoreShortAnswerWritingLife extends ShortAnswerWritingEvent {}

class ShortAnswerWritingHintUsed extends ShortAnswerWritingEvent {}
