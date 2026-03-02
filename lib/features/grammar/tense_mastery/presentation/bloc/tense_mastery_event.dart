import 'package:equatable/equatable.dart';

abstract class TenseMasteryEvent extends Equatable {
  const TenseMasteryEvent();

  @override
  List<Object?> get props => [];
}

class FetchTenseMasteryQuests extends TenseMasteryEvent {
  final int level;

  const FetchTenseMasteryQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitTenseMasteryAnswer extends TenseMasteryEvent {
  final bool isCorrect;

  const SubmitTenseMasteryAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextTenseMasteryQuestion extends TenseMasteryEvent {}

class RestoreTenseMasteryLife extends TenseMasteryEvent {}

class TenseMasteryHintUsed extends TenseMasteryEvent {}
