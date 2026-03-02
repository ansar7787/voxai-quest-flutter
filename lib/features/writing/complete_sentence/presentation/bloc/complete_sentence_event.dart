import 'package:equatable/equatable.dart';

abstract class CompleteSentenceEvent extends Equatable {
  const CompleteSentenceEvent();

  @override
  List<Object?> get props => [];
}

class FetchCompleteSentenceQuests extends CompleteSentenceEvent {
  final int level;

  const FetchCompleteSentenceQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitCompleteSentenceAnswer extends CompleteSentenceEvent {
  final bool isCorrect;

  const SubmitCompleteSentenceAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextCompleteSentenceQuestion extends CompleteSentenceEvent {}

class RestoreCompleteSentenceLife extends CompleteSentenceEvent {}

class CompleteSentenceHintUsed extends CompleteSentenceEvent {}
