import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class SpeakingQuest extends GameQuest {
  final String? textToSpeak;
  final String? missingWord;
  final String? prompt;
  final String? sampleAnswer;
  final String? explanation;
  final String? translation;
  final String? situationText;
  final String? sceneText;
  final List<String>? acceptedSynonyms;
  final String? phoneticHint;
  final String? meaning;
  final String? sampleUsage;

  const SpeakingQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.interactionType = InteractionType.speech,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.options,
    super.correctAnswerIndex,
    super.correctAnswer,
    super.hint,
    this.textToSpeak,
    this.missingWord,
    this.prompt,
    this.sampleAnswer,
    this.explanation,
    this.translation,
    this.situationText,
    this.sceneText,
    this.acceptedSynonyms,
    this.phoneticHint,
    this.meaning,
    this.sampleUsage,
  });
}
