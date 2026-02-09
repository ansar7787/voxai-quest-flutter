import 'package:voxai_quest/features/game/domain/entities/game_quest.dart';

class ReadingQuest extends GameQuest {
  final String passage;
  final List<String> options;
  final int correctOptionIndex;

  ReadingQuest({
    required super.id,
    required super.instruction,
    required super.difficulty,
    required this.passage,
    required this.options,
    required this.correctOptionIndex,
  }) : super(type: QuestType.reading);
}
