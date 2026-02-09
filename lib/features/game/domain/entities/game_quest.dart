enum QuestType { speaking, reading, writing }

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

class SpeakingQuest extends GameQuest {
  final String textToSpeak;

  SpeakingQuest({
    required super.id,
    required super.instruction,
    required super.difficulty,
    required this.textToSpeak,
  }) : super(type: QuestType.speaking);
}
