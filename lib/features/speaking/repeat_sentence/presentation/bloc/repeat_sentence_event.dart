import 'package:equatable/equatable.dart';

abstract class RepeatSentenceEvent extends Equatable {
  const RepeatSentenceEvent();

  @override
  List<Object?> get props => [];
}

class FetchRepeatSentenceQuests extends RepeatSentenceEvent {
  final int level;

  const FetchRepeatSentenceQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitRepeatSentenceAnswer extends RepeatSentenceEvent {
  final bool isCorrect;

  const SubmitRepeatSentenceAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextRepeatSentenceQuestion extends RepeatSentenceEvent {}

class RestoreRepeatSentenceLife extends RepeatSentenceEvent {}
