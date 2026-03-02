import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/core/utils/enum_parser.dart';
import 'package:voxai_quest/features/roleplay/social_spark/domain/entities/social_spark_quest.dart';

class SocialSparkQuestModel extends SocialSparkQuest {
  const SocialSparkQuestModel({
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
    super.setting,
    super.socialContext,
    super.conversationStarter,
    super.conversationalHooks,
    super.closure,
  });

  factory SocialSparkQuestModel.fromJson(Map<String, dynamic> json) {
    return SocialSparkQuestModel(
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
      setting: json['setting'] as String?,
      socialContext: json['socialContext'] as String?,
      conversationStarter: json['conversationStarter'] as String?,
      conversationalHooks: (json['conversationalHooks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      closure: json['closure'] as String?,
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
      'setting': setting,
      'socialContext': socialContext,
      'conversationStarter': conversationStarter,
      'conversationalHooks': conversationalHooks,
      'closure': closure,
    };
  }
}
