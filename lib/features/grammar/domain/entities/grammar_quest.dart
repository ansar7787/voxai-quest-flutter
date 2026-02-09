import 'package:voxai_quest/features/game/domain/entities/game_quest.dart';

class GrammarQuest extends GameQuest {
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  GrammarQuest({
    required super.id,
    required super.instruction,
    required super.difficulty,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  }) : super(type: QuestType.grammar);
}
