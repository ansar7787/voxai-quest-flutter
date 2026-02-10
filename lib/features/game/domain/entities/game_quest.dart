enum QuestType {
  speaking,
  reading,
  writing,
  grammar,
  conversation,
  pronunciation,
}

abstract class GameQuest {
  final String id;
  final String instruction;
  final QuestType type;
  final int difficulty;

  GameQuest({
    required this.id,
    required this.instruction,
    required this.type,
    required this.difficulty,
  });
}
