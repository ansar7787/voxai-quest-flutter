import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class AccentQuest extends GameQuest {
  final String? word;
  final String? phoneticHint;
  final String? targetWord;
  final String? prompt;
  final String? sampleAnswer;
  final String? explanation;
  final String? audioUrl;
  final List<String>? words;
  final List<int>? intonationMap;
  final List<String>? syllables;
  final double? targetSpeed;
  final List<int>? pitchPatterns;

  const AccentQuest({
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
    this.word,
    this.phoneticHint,
    this.targetWord,
    super.textToSpeak,
    this.prompt,
    this.sampleAnswer,
    this.explanation,
    this.audioUrl,
    this.words,
    this.intonationMap,
    this.syllables,
    this.targetSpeed,
    this.pitchPatterns,
  });

  String? get phonetic => phoneticHint;

  @override
  List<Object?> get props => [
    ...super.props,
    word,
    phoneticHint,
    targetWord,
    prompt,
    sampleAnswer,
    explanation,
    audioUrl,
    words,
    intonationMap,
    syllables,
    targetSpeed,
    pitchPatterns,
  ];
}
