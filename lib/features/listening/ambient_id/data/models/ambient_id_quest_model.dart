import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/features/listening/ambient_id/domain/entities/ambient_id_quest.dart';

class AmbientIdQuestModel extends AmbientIdQuest {
  const AmbientIdQuestModel({
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
    super.transcript,
    super.hint,
    super.textToSpeak,
  });

  factory AmbientIdQuestModel.fromJson(Map<String, dynamic> json) {
    return AmbientIdQuestModel(
      id: json['id'] as String? ?? '',
      type: QuestType.listening,
      subtype: GameSubtype.ambientId,
      instruction:
          json['instruction'] as String? ?? 'Identify the ambient sound.',
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 10,
      coinReward: (json['coinReward'] as num?)?.toInt() ?? 10,
      livesAllowed: (json['livesAllowed'] as num?)?.toInt() ?? 3,
      interactionType: InteractionType.choice,
      audioUrl: (json['audioUrl'] ?? json['ambientAudioUrl']) as String?,
      textToSpeak: json['textToSpeak'] as String?,
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      correctAnswerIndex: (json['correctAnswerIndex'] as num?)?.toInt() ?? 0,
      hint: json['hint'] as String?,
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
      'audioUrl': audioUrl,
      'textToSpeak': textToSpeak,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'hint': hint,
      'transcript': transcript,
    };
  }
}
