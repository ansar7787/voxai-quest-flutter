import 'package:voxai_quest/features/speaking/domain/entities/speaking_quest.dart';

class SpeakingQuestModel extends SpeakingQuest {
  SpeakingQuestModel({
    required super.id,
    required super.instruction,
    required super.difficulty,
    required super.textToSpeak,
  });

  factory SpeakingQuestModel.fromJson(Map<String, dynamic> json) {
    return SpeakingQuestModel(
      id: json['id'] ?? '',
      instruction: json['instruction'] ?? '',
      difficulty: json['difficulty'] ?? 1,
      textToSpeak: json['textToSpeak'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instruction': instruction,
      'difficulty': difficulty,
      'textToSpeak': textToSpeak,
      'type': 'speaking',
    };
  }
}
