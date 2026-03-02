import 'package:equatable/equatable.dart';

abstract class ElevatorPitchEvent extends Equatable {
  const ElevatorPitchEvent();

  @override
  List<Object?> get props => [];
}

class FetchElevatorPitchQuests extends ElevatorPitchEvent {
  final int level;
  const FetchElevatorPitchQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitElevatorPitchAnswer extends ElevatorPitchEvent {
  final bool isCorrect;
  const SubmitElevatorPitchAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextElevatorPitchQuestion extends ElevatorPitchEvent {}

class RestoreElevatorPitchLife extends ElevatorPitchEvent {}

class ElevatorPitchHintUsed extends ElevatorPitchEvent {}


class RestartLevel extends ElevatorPitchEvent {}

