import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/core/utils/enum_parser.dart';
import 'package:voxai_quest/features/roleplay/branching_dialogue/domain/entities/branching_dialogue_quest.dart';

class BranchingDialogueQuestModel extends BranchingDialogueQuest {
  const BranchingDialogueQuestModel({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.choice,
    super.options,
    super.correctAnswerIndex,
    super.scenario,
    super.persona,
    super.lastLine,
    super.nodes,
  });

  factory BranchingDialogueQuestModel.fromJson(Map<String, dynamic> json) {
    return BranchingDialogueQuestModel(
      id: json['id'] as String? ?? '',
      type: EnumParser.fromString(
        json['type'] as String?,
        QuestType.values,
        defaultValue: QuestType.speaking,
      ),
      instruction: json['instruction'] as String? ?? '',
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      subtype: EnumParser.fromString(
        json['subtype'] as String?,
        GameSubtype.values,
        defaultValue: GameSubtype.repeatSentence,
      ),
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 10,
      coinReward: (json['coinReward'] as num?)?.toInt() ?? 10,
      livesAllowed: (json['livesAllowed'] as num?)?.toInt() ?? 3,
      interactionType: EnumParser.parseInteractionType(
        json['interactionType'] as String?,
      ),
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      correctAnswerIndex: (json['correctAnswerIndex'] as num?)?.toInt(),
      scenario: json['scenario'] as String?,
      persona: json['persona'] as String?,
      lastLine: json['lastLine'] as String?,
      nodes: json['nodes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'instruction': instruction,
      'difficulty': difficulty,
      'subtype': subtype,
      'xpReward': xpReward,
      'coinReward': coinReward,
      'livesAllowed': livesAllowed,
      'interactionType': interactionType,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'scenario': scenario,
      'persona': persona,
      'lastLine': lastLine,
      'nodes': nodes,
    };
  }
}
