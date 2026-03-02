import 'package:equatable/equatable.dart';

abstract class FixTheSentenceEvent extends Equatable {
  const FixTheSentenceEvent();

  @override
  List<Object?> get props => [];
}

class FetchFixTheSentenceQuests extends FixTheSentenceEvent {
  final int level;

  const FetchFixTheSentenceQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitFixTheSentenceAnswer extends FixTheSentenceEvent {
  final bool isCorrect;

  const SubmitFixTheSentenceAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextFixTheSentenceQuestion extends FixTheSentenceEvent {}

class RestoreFixTheSentenceLife extends FixTheSentenceEvent {}

class FixTheSentenceHintUsed extends FixTheSentenceEvent {}
