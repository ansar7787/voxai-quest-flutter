import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/features/listening/audio_true_false/domain/entities/audio_true_false_quest.dart';

class AudioTrueFalseQuestModel extends AudioTrueFalseQuest {
  const AudioTrueFalseQuestModel({
    required super.id,
    super.type = QuestType.listening,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.interactionType = InteractionType.trueFalse,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.audioUrl,
    super.statement,
    super.isTrue,
    super.textToSpeak,
    super.transcript,
    super.hint,
  });

  factory AudioTrueFalseQuestModel.fromJson(Map<String, dynamic> json) {
    return AudioTrueFalseQuestModel(
      id: json['id'] as String? ?? '',
      type: QuestType.listening,
      subtype: GameSubtype.audioTrueFalse,
      instruction:
          json['instruction'] as String? ??
          'Is the statement about the audio True or False?',
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 10,
      coinReward: (json['coinReward'] as num?)?.toInt() ?? 10,
      livesAllowed: (json['livesAllowed'] as num?)?.toInt() ?? 3,
      interactionType: InteractionType.trueFalse,
      textToSpeak: json['textToSpeak'] as String? ?? '',
      statement: json['statement'] as String? ?? '',
      isTrue: (json['isTrue'] ?? json['correctAnswer']) as bool? ?? true,
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
      'statement': statement,
      'isTrue': isTrue,
      'hint': hint,
      'audioUrl': audioUrl,
      'transcript': transcript,
    };
  }
}
