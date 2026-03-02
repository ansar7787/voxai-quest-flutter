import 'package:voxai_quest/features/listening/audio_fill_blanks/domain/entities/audio_fill_blanks_quest.dart';
import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class AudioFillBlanksQuestModel extends AudioFillBlanksQuest {
  const AudioFillBlanksQuestModel({
    required super.id,
    super.type = QuestType.listening,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.interactionType = InteractionType.writing,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.options,
    super.correctAnswerIndex,
    super.correctAnswer,
    super.hint,
    super.audioUrl,
    super.textToSpeak,
    super.transcript,
    required super.missingWord,
  });

  factory AudioFillBlanksQuestModel.fromJson(Map<String, dynamic> json) {
    return AudioFillBlanksQuestModel(
      id: json['id'] as String? ?? '',
      type: QuestType.listening,
      subtype: GameSubtype.audioFillBlanks,
      instruction:
          json['instruction'] as String? ??
          'Type the missing word from the audio.',
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 10,
      coinReward: (json['coinReward'] as num?)?.toInt() ?? 10,
      livesAllowed: (json['livesAllowed'] as num?)?.toInt() ?? 3,
      interactionType: InteractionType.writing,
      textToSpeak: json['textToSpeak'] as String? ?? '',
      missingWord: json['missingWord'] as String? ?? '',
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
      'missingWord': missingWord,
      'hint': hint,
      'audioUrl': audioUrl,
      'transcript': transcript,
    };
  }
}
