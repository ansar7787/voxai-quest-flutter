import 'package:equatable/equatable.dart';

abstract class PhrasalVerbsEvent extends Equatable {
  const PhrasalVerbsEvent();

  @override
  List<Object?> get props => [];
}

class FetchPhrasalVerbsQuests extends PhrasalVerbsEvent {
  final int level;

  const FetchPhrasalVerbsQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitPhrasalVerbsAnswer extends PhrasalVerbsEvent {
  final bool isCorrect;

  const SubmitPhrasalVerbsAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextPhrasalVerbsQuestion extends PhrasalVerbsEvent {}

class RestorePhrasalVerbsLife extends PhrasalVerbsEvent {}

class PhrasalVerbsHintUsed extends PhrasalVerbsEvent {}
