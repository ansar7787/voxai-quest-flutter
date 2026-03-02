import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/features/listening/emotion_recognition/domain/entities/emotion_recognition_quest.dart';

class EmotionRecognitionQuestModel extends EmotionRecognitionQuest {
  const EmotionRecognitionQuestModel({
    required super.id,
    super.type = QuestType.listening,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.interactionType = InteractionType.choice,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.audioUrl,
    super.options,
    super.correctAnswerIndex,
    super.textToSpeak,
    super.transcript,
    super.hint,
  });

  factory EmotionRecognitionQuestModel.fromJson(Map<String, dynamic> json) {
    return EmotionRecognitionQuestModel(
      id: json['id'] as String? ?? '',
      type: QuestType.listening,
      subtype: GameSubtype.emotionRecognition,
      instruction:
          json['instruction'] as String? ?? 'Identify the speaker\'s emotion.',
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 10,
      coinReward: (json['coinReward'] as num?)?.toInt() ?? 10,
      livesAllowed: (json['livesAllowed'] as num?)?.toInt() ?? 3,
      interactionType: InteractionType.choice,
      textToSpeak: json['textToSpeak'] as String? ?? '',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      correctAnswerIndex: (json['correctAnswerIndex'] as num?)?.toInt() ?? 0,
      hint: json['hint'] as String?,
      audioUrl: json['audioUrl'] as String?,
      transcript: json['transcript'] as String?,
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
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'hint': hint,
      'audioUrl': audioUrl,
      'transcript': transcript,
    };
  }
}
