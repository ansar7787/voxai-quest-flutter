import 'package:equatable/equatable.dart';

abstract class MedicalConsultEvent extends Equatable {
  const MedicalConsultEvent();

  @override
  List<Object?> get props => [];
}

class FetchMedicalConsultQuests extends MedicalConsultEvent {
  final int level;
  const FetchMedicalConsultQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitMedicalConsultAnswer extends MedicalConsultEvent {
  final bool isCorrect;
  const SubmitMedicalConsultAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextMedicalConsultQuestion extends MedicalConsultEvent {}

class RestoreMedicalConsultLife extends MedicalConsultEvent {}

class MedicalConsultHintUsed extends MedicalConsultEvent {}


class RestartLevel extends MedicalConsultEvent {}

