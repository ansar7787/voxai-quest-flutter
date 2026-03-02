import 'package:equatable/equatable.dart';

abstract class QuestionFormatterEvent extends Equatable {
  const QuestionFormatterEvent();

  @override
  List<Object?> get props => [];
}

class FetchQuestionFormatterQuests extends QuestionFormatterEvent {
  final int level;

  const FetchQuestionFormatterQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitQuestionFormatterAnswer extends QuestionFormatterEvent {
  final bool isCorrect;

  const SubmitQuestionFormatterAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextQuestionFormatterQuestion extends QuestionFormatterEvent {}

class RestoreQuestionFormatterLife extends QuestionFormatterEvent {}

class QuestionFormatterHintUsed extends QuestionFormatterEvent {}
