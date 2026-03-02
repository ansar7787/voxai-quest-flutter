import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/core/utils/enum_parser.dart';
import 'package:voxai_quest/features/roleplay/emergency_hub/domain/entities/emergency_hub_quest.dart';

class EmergencyHubQuestModel extends EmergencyHubQuest {
  const EmergencyHubQuestModel({
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
    super.emergencyType,
    super.urgencyLevel,
    super.requiredActions,
    super.callerState,
    super.dispatcherFeedback,
  });

  factory EmergencyHubQuestModel.fromJson(Map<String, dynamic> json) {
    return EmergencyHubQuestModel(
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
      interactionType: EnumParser.parseInteractionType(json['interactionType'] as String?),
      options: (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
      correctAnswerIndex: (json['correctAnswerIndex'] as num?)?.toInt(),
      emergencyType: json['emergencyType'] as String?,
      urgencyLevel: json['urgencyLevel'] as String?,
      requiredActions: (json['requiredActions'] as List<dynamic>?)?.map((e) => e as String).toList(),
      callerState: json['callerState'] as String?,
      dispatcherFeedback: json['dispatcherFeedback'] as String?,
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
      'emergencyType': emergencyType,
      'urgencyLevel': urgencyLevel,
      'requiredActions': requiredActions,
      'callerState': callerState,
      'dispatcherFeedback': dispatcherFeedback,
    };
  }
}

