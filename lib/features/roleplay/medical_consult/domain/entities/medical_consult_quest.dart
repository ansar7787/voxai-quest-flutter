import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class MedicalConsultQuest extends GameQuest {
  final String? patientName;
  final String? condition;
  final String? patientQuery;
  final List<String>? keySymptoms;
  final String? advice;

  const MedicalConsultQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType,
    super.options,
    super.correctAnswerIndex,
    this.patientName,
    this.condition,
    this.patientQuery,
    this.keySymptoms,
    this.advice,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    patientName,
    condition,
    patientQuery,
    keySymptoms,
    advice,
  ];
}
