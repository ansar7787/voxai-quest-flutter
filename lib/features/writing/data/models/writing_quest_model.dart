import 'package:voxai_quest/features/writing/domain/entities/writing_quest.dart';

class WritingQuestModel extends WritingQuest {
  WritingQuestModel({
    required super.id,
    required super.instruction,
    required super.difficulty,
    required super.prompt,
    required super.expectedAnswer,
  });

  factory WritingQuestModel.fromJson(Map<String, dynamic> json) {
    return WritingQuestModel(
      id: json['id'] ?? '',
      instruction: json['instruction'] ?? '',
      difficulty: json['difficulty'] ?? 1,
      prompt: json['prompt'] ?? '',
      expectedAnswer: json['expectedAnswer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instruction': instruction,
      'difficulty': difficulty,
      'prompt': prompt,
      'expectedAnswer': expectedAnswer,
      'type': 'writing',
    };
  }
}
