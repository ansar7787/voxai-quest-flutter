import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class ConflictResolverQuest extends GameQuest {
  final String? scenario;
  final String? antagonistName;
  final String? conflictPoint;
  final List<String>? deEscalationTechniques;
  final String? resolution;

  const ConflictResolverQuest({
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
    this.scenario,
    this.antagonistName,
    this.conflictPoint,
    this.deEscalationTechniques,
    this.resolution,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    scenario,
    antagonistName,
    conflictPoint,
    deEscalationTechniques,
    resolution,
  ];
}
