import 'package:voxai_quest/features/speaking/domain/entities/pronunciation_quest.dart';

class PronunciationQuestModel extends PronunciationQuest {
  PronunciationQuestModel({
    required super.id,
    required super.instruction,
    required super.difficulty,
    required super.word,
    required super.phonetic,
    super.audioUrl = "",
  });

  factory PronunciationQuestModel.fromJson(Map<String, dynamic> json) {
    return PronunciationQuestModel(
      id: json['id'] ?? '',
      instruction: json['instruction'] ?? '',
      difficulty: json['difficulty'] ?? 1,
      word: json['word'] ?? '',
      phonetic: json['phonetic'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instruction': instruction,
      'difficulty': difficulty,
      'word': word,
      'phonetic': phonetic,
      'audioUrl': audioUrl,
      'type': 'pronunciation',
    };
  }
}
