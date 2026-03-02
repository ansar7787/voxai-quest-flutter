import 'package:equatable/equatable.dart';

abstract class EmergencyHubEvent extends Equatable {
  const EmergencyHubEvent();

  @override
  List<Object?> get props => [];
}

class FetchEmergencyHubQuests extends EmergencyHubEvent {
  final int level;
  const FetchEmergencyHubQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitEmergencyHubAnswer extends EmergencyHubEvent {
  final bool isCorrect;
  const SubmitEmergencyHubAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextEmergencyHubQuestion extends EmergencyHubEvent {}

class RestoreEmergencyHubLife extends EmergencyHubEvent {}

class EmergencyHubHintUsed extends EmergencyHubEvent {}

class RestartLevel extends EmergencyHubEvent {}
