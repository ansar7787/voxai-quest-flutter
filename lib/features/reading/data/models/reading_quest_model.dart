import 'package:voxai_quest/features/reading/domain/entities/reading_quest.dart';

class ReadingQuestModel extends ReadingQuest {
  ReadingQuestModel({
    required super.id,
    required super.instruction,
    required super.difficulty,
    required super.passage,
    required super.options,
    required super.correctOptionIndex,
  });

  factory ReadingQuestModel.fromJson(Map<String, dynamic> json) {
    return ReadingQuestModel(
      id: json['id'] ?? '',
      instruction: json['instruction'] ?? '',
      difficulty: json['difficulty'] ?? 1,
      passage: json['passage'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctOptionIndex: json['correctOptionIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instruction': instruction,
      'difficulty': difficulty,
      'passage': passage,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'type': 'reading',
    };
  }
}
