import 'package:equatable/equatable.dart';

abstract class TrueFalseReadingEvent extends Equatable {
  const TrueFalseReadingEvent();

  @override
  List<Object?> get props => [];
}

class FetchTrueFalseReadingQuests extends TrueFalseReadingEvent {
  final int level;

  const FetchTrueFalseReadingQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitTrueFalseReadingAnswer extends TrueFalseReadingEvent {
  final bool isCorrect;

  const SubmitTrueFalseReadingAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextTrueFalseReadingQuestion extends TrueFalseReadingEvent {}

class RestoreTrueFalseReadingLife extends TrueFalseReadingEvent {}

class TrueFalseReadingHintUsed extends TrueFalseReadingEvent {}
