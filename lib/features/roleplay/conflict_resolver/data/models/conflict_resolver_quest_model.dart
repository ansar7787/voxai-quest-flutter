import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/core/utils/enum_parser.dart';
import 'package:voxai_quest/features/roleplay/conflict_resolver/domain/entities/conflict_resolver_quest.dart';

class ConflictResolverQuestModel extends ConflictResolverQuest {
  const ConflictResolverQuestModel({
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
    super.antagonistName,
    super.conflictPoint,
    super.deEscalationTechniques,
    super.resolution,
  });

  factory ConflictResolverQuestModel.fromJson(Map<String, dynamic> json) {
    return ConflictResolverQuestModel(
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
      antagonistName: json['antagonistName'] as String?,
      conflictPoint: json['conflictPoint'] as String?,
      deEscalationTechniques: (json['deEscalationTechniques'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      resolution: json['resolution'] as String?,
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
      'antagonistName': antagonistName,
      'conflictPoint': conflictPoint,
      'deEscalationTechniques': deEscalationTechniques,
      'resolution': resolution,
    };
  }
}
