import 'package:equatable/equatable.dart';

abstract class ReadAndAnswerEvent extends Equatable {
  const ReadAndAnswerEvent();

  @override
  List<Object?> get props => [];
}

class FetchReadAndAnswerQuests extends ReadAndAnswerEvent {
  final int level;

  const FetchReadAndAnswerQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitReadAndAnswerAnswer extends ReadAndAnswerEvent {
  final bool isCorrect;

  const SubmitReadAndAnswerAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextReadAndAnswerQuestion extends ReadAndAnswerEvent {}

class RestoreReadAndAnswerLife extends ReadAndAnswerEvent {}

class ReadAndAnswerHintUsed extends ReadAndAnswerEvent {}
