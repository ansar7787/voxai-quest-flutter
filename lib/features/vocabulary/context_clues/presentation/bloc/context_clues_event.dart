import 'package:equatable/equatable.dart';

abstract class ContextCluesEvent extends Equatable {
  const ContextCluesEvent();

  @override
  List<Object?> get props => [];
}

class FetchContextCluesQuests extends ContextCluesEvent {
  final int level;

  const FetchContextCluesQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitContextCluesAnswer extends ContextCluesEvent {
  final bool isCorrect;

  const SubmitContextCluesAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextContextCluesQuestion extends ContextCluesEvent {}

class RestoreContextCluesLife extends ContextCluesEvent {}

class ContextCluesHintUsed extends ContextCluesEvent {}
