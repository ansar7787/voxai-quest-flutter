import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/core/utils/enum_parser.dart';
import 'package:voxai_quest/features/reading/sentence_order_reading/domain/entities/sentence_order_reading_quest.dart';

class SentenceOrderReadingQuestModel extends SentenceOrderReadingQuest {
  const SentenceOrderReadingQuestModel({
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
    super.correctAnswer,
    super.hint,
    super.shuffledSentences,
    super.correctOrder,
  });

  factory SentenceOrderReadingQuestModel.fromJson(Map<String, dynamic> json) {
    return SentenceOrderReadingQuestModel(
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
      correctAnswer: json['correctAnswer'] as String?,
      hint: json['hint'] as String?,
      shuffledSentences: (json['shuffledSentences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      correctOrder: (json['correctOrder'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
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
      'correctAnswer': correctAnswer,
      'hint': hint,
      'shuffledSentences': shuffledSentences,
      'correctOrder': correctOrder,
    };
  }
}
