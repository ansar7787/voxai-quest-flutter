import 'package:voxai_quest/features/grammar/domain/entities/grammar_quest.dart';

class GrammarQuestModel extends GrammarQuest {
  GrammarQuestModel({
    required super.id,
    required super.instruction,
    required super.difficulty,
    required super.question,
    required super.options,
    required super.correctOptionIndex,
    required super.explanation,
  });

  factory GrammarQuestModel.fromJson(Map<String, dynamic> json) {
    return GrammarQuestModel(
      id: json['id'] ?? '',
      instruction: json['instruction'] ?? '',
      difficulty: json['difficulty'] ?? 1,
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctOptionIndex: json['correctOptionIndex'] ?? 0,
      explanation: json['explanation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instruction': instruction,
      'difficulty': difficulty,
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
      'type': 'grammar',
      'level': difficulty, // Add level explicitly for query ease
    };
  }
}
