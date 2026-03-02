import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/features/listening/fast_speech_decoder/domain/entities/fast_speech_decoder_quest.dart';

class FastSpeechDecoderQuestModel extends FastSpeechDecoderQuest {
  const FastSpeechDecoderQuestModel({
    required super.id,
    super.type = QuestType.listening,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.interactionType = InteractionType.typing,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.audioUrl,
    super.correctAnswer,
    super.textToSpeak,
    super.transcript,
    super.hint,
  });

  factory FastSpeechDecoderQuestModel.fromJson(Map<String, dynamic> json) {
    return FastSpeechDecoderQuestModel(
      id: json['id'] as String? ?? '',
      type: QuestType.listening,
      subtype: GameSubtype.fastSpeechDecoder,
      instruction:
          json['instruction'] as String? ??
          'Listen and type exactly what you hear.',
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 10,
      coinReward: (json['coinReward'] as num?)?.toInt() ?? 10,
      livesAllowed: (json['livesAllowed'] as num?)?.toInt() ?? 3,
      interactionType: InteractionType.typing,
      textToSpeak: json['textToSpeak'] as String? ?? '',
      correctAnswer: json['correctAnswer'] as String? ?? '',
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
      'correctAnswer': correctAnswer,
      'hint': hint,
      'audioUrl': audioUrl,
      'transcript': transcript,
    };
  }
}
