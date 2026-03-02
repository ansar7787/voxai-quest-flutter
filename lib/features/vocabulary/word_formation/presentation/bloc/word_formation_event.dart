import 'package:equatable/equatable.dart';

abstract class WordFormationEvent extends Equatable {
  const WordFormationEvent();

  @override
  List<Object?> get props => [];
}

class FetchWordFormationQuests extends WordFormationEvent {
  final int level;

  const FetchWordFormationQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitWordFormationAnswer extends WordFormationEvent {
  final bool isCorrect;

  const SubmitWordFormationAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextWordFormationQuestion extends WordFormationEvent {}

class RestoreWordFormationLife extends WordFormationEvent {}

class WordFormationHintUsed extends WordFormationEvent {}
