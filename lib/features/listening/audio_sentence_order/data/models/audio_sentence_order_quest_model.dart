import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/features/listening/audio_sentence_order/domain/entities/audio_sentence_order_quest.dart';

class AudioSentenceOrderQuestModel extends AudioSentenceOrderQuest {
  const AudioSentenceOrderQuestModel({
    required super.id,
    super.type = QuestType.listening,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.interactionType = InteractionType.reorder,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.audioUrl,
    super.shuffledSentences,
    super.correctOrder,
    super.textToSpeak,
    super.hint,
  });

  factory AudioSentenceOrderQuestModel.fromJson(Map<String, dynamic> json) {
    return AudioSentenceOrderQuestModel(
      id: json['id'] as String? ?? '',
      type: QuestType.listening,
      subtype: GameSubtype.audioSentenceOrder,
      instruction:
          json['instruction'] as String? ??
          'Reorder the words to match the audio.',
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 10,
      coinReward: (json['coinReward'] as num?)?.toInt() ?? 10,
      livesAllowed: (json['livesAllowed'] as num?)?.toInt() ?? 3,
      interactionType: InteractionType.sequence,
      textToSpeak: json['textToSpeak'] as String? ?? '',
      shuffledSentences:
          (json['shuffledSentences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      correctOrder:
          (json['correctOrder'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      hint: json['hint'] as String?,
      audioUrl: json['audioUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type?.name,
      'subtype': subtype?.name,
      'instruction': instruction,
      'difficulty': difficulty,
      'interactionType': interactionType.name,
      'xpReward': xpReward,
      'coinReward': coinReward,
      'livesAllowed': livesAllowed,
      'textToSpeak': textToSpeak,
      'shuffledSentences': shuffledSentences,
      'correctOrder': correctOrder,
      'hint': hint,
      'audioUrl': audioUrl,
    };
  }
}
