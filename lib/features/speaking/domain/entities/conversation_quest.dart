import 'package:voxai_quest/features/game/domain/entities/game_quest.dart';

class ConversationQuest extends GameQuest {
  final String roleName;
  final String aiPrompt;
  final List<String> targetKeyPhrases;

  ConversationQuest({
    required super.id,
    required super.instruction,
    required super.difficulty,
    required this.roleName,
    required this.aiPrompt,
    required this.targetKeyPhrases,
  }) : super(type: QuestType.conversation);
}
