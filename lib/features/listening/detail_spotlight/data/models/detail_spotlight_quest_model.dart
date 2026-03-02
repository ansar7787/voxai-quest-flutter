import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/features/listening/detail_spotlight/domain/entities/detail_spotlight_quest.dart';

class DetailSpotlightQuestModel extends DetailSpotlightQuest {
  const DetailSpotlightQuestModel({
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
    super.question,
    super.options,
    super.correctAnswerIndex,
    super.textToSpeak,
    super.transcript,
    super.hint,
  });

  factory DetailSpotlightQuestModel.fromJson(Map<String, dynamic> json) {
    return DetailSpotlightQuestModel(
      id: json['id'] as String? ?? '',
      type: QuestType.listening,
      subtype: GameSubtype.detailSpotlight,
      instruction:
          json['instruction'] as String? ??
          'Listen for refined details and answer.',
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 1,
      xpReward: (json['xpReward'] as num?)?.toInt() ?? 10,
      coinReward: (json['coinReward'] as num?)?.toInt() ?? 10,
      livesAllowed: (json['livesAllowed'] as num?)?.toInt() ?? 3,
      interactionType: InteractionType.choice,
      textToSpeak: json['textToSpeak'] as String? ?? '',
      question: json['question'] as String? ?? '',
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
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'hint': hint,
      'audioUrl': audioUrl,
      'transcript': transcript,
    };
  }
}
