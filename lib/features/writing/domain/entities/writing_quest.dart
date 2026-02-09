import 'package:voxai_quest/features/game/domain/entities/game_quest.dart';

class WritingQuest extends GameQuest {
  final String prompt;
  final String expectedAnswer;

  WritingQuest({
    required super.id,
    required super.instruction,
    required super.difficulty,
    required this.prompt,
    required this.expectedAnswer,
  }) : super(type: QuestType.writing);
}
