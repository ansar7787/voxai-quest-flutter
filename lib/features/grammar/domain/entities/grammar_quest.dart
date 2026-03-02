import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class GrammarQuest extends GameQuest {
  final String? sentence;
  final String? missingWord;
  final String? incorrectPart;
  final String? correctedPart;
  final List<String>? shuffledWords;
  final List<int>? correctOrder;
  final String? explanation;
  final String? prompt;
  final String? verb;
  final String? word;
  final String? targetTense;
  final String? secondarySentence;

  const GrammarQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.interactionType = InteractionType.choice,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.options,
    super.correctAnswerIndex,
    super.correctAnswer,
    super.hint,
    this.sentence,
    this.missingWord,
    this.incorrectPart,
    this.correctedPart,
    this.shuffledWords,
    this.correctOrder,
    this.explanation,
    this.prompt,
    super.textToSpeak,
    this.verb,
    this.word,
    this.targetTense,
    this.secondarySentence,
  });

  String? get question => sentence;
  String? get correctSentence => correctAnswer;
}
