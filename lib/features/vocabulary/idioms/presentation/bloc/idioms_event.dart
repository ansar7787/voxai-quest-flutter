import 'package:equatable/equatable.dart';

abstract class IdiomsEvent extends Equatable {
  const IdiomsEvent();

  @override
  List<Object?> get props => [];
}

class FetchIdiomsQuests extends IdiomsEvent {
  final int level;

  const FetchIdiomsQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitIdiomsAnswer extends IdiomsEvent {
  final bool isCorrect;

  const SubmitIdiomsAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextIdiomsQuestion extends IdiomsEvent {}

class RestoreIdiomsLife extends IdiomsEvent {}

class IdiomsHintUsed extends IdiomsEvent {}
