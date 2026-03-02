import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/core/utils/enum_parser.dart';
import 'package:voxai_quest/features/roleplay/gourmet_order/domain/entities/gourmet_order_quest.dart';

class GourmetOrderQuestModel extends GourmetOrderQuest {
  const GourmetOrderQuestModel({
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
    super.customerName,
    super.orderDetails,
    super.ingredients,
    super.specialRequest,
    super.response,
  });

  factory GourmetOrderQuestModel.fromJson(Map<String, dynamic> json) {
    return GourmetOrderQuestModel(
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
      customerName: json['customerName'] as String?,
      orderDetails: json['orderDetails'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>?)?.map((e) => e as String).toList(),
      specialRequest: json['specialRequest'] as String?,
      response: json['response'] as String?,
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
      'customerName': customerName,
      'orderDetails': orderDetails,
      'ingredients': ingredients,
      'specialRequest': specialRequest,
      'response': response,
    };
  }
}

