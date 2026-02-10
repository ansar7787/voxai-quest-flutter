import 'package:voxai_quest/features/speaking/domain/entities/conversation_quest.dart';

class ConversationQuestModel extends ConversationQuest {
  ConversationQuestModel({
    required super.id,
    required super.instruction,
    required super.difficulty,
    required super.roleName,
    required super.aiPrompt,
    required super.targetKeyPhrases,
  });

  factory ConversationQuestModel.fromJson(Map<String, dynamic> json) {
    return ConversationQuestModel(
      id: json['id'] ?? '',
      instruction: json['instruction'] ?? '',
      difficulty: json['difficulty'] ?? 1,
      roleName: json['roleName'] ?? 'AI Tutor',
      aiPrompt: json['aiPrompt'] ?? '',
      targetKeyPhrases: List<String>.from(json['targetKeyPhrases'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instruction': instruction,
      'difficulty': difficulty,
      'roleName': roleName,
      'aiPrompt': aiPrompt,
      'targetKeyPhrases': targetKeyPhrases,
      'type': 'conversation',
    };
  }
}
