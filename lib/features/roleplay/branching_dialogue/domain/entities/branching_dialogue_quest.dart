import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class BranchingDialogueQuest extends GameQuest {
  final String? scenario;
  final String? persona;
  final String? lastLine;
  final dynamic nodes;

  const BranchingDialogueQuest({
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
    this.persona,
    this.lastLine,
    this.nodes,
  });

  String? get roleName => persona;
  String? get npcLine => lastLine;

  @override
  List<Object?> get props => [
        ...super.props,
        scenario,
        persona,
        lastLine,
        nodes,
      ];
}
