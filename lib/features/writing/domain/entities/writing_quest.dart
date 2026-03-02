import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class WritingQuest extends GameQuest {
  final String? passage;
  final String? question;
  final String? missingWord;
  final String? prompt;
  final String? sampleAnswer;
  final String? explanation;
  final List<String>? shuffledSentences;
  final List<int>? correctOrder;
  final String? story;
  final String? situation;
  final String? prefix;
  final String? suffix;
  final int? minWords;
  final List<String>? requiredPoints;

  const WritingQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.interactionType = InteractionType.writing,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.options,
    super.correctAnswerIndex,
    super.correctAnswer,
    super.hint,
    this.passage,
    this.question,
    super.textToSpeak,
    this.missingWord,
    this.prompt,
    this.sampleAnswer,
    this.explanation,
    this.shuffledSentences,
    this.correctOrder,
    this.story,
    this.situation,
    this.prefix,
    this.suffix,
    this.minWords,
    this.requiredPoints,
  });

  String? get incorrectSentence => passage;
  String? get correctSentence => correctAnswer;
  List<String>? get shuffledWords => shuffledSentences;
}
