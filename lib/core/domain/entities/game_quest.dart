import 'package:equatable/equatable.dart';

enum InteractionType {
  speech,
  choice,
  writing,
  sequence,
  match,
  speaking,
  typing,
  reorder,
  trueFalse,
  text,
}

enum GameSubtype {
  // 1. Speaking
  repeatSentence,
  speakMissingWord,
  situationSpeaking,
  sceneDescriptionSpeaking,
  yesNoSpeaking,
  speakSynonym,
  dialogueRoleplay,
  pronunciationFocus,
  speakOpposite,
  dailyExpression,
  // 2. Listening
  audioFillBlanks,
  audioMultipleChoice,
  audioSentenceOrder,
  audioTrueFalse,
  soundImageMatch,
  fastSpeechDecoder,
  emotionRecognition,
  detailSpotlight,
  listeningInference,
  ambientId,
  // 3. Reading
  readAndAnswer,
  findWordMeaning,
  trueFalseReading,
  sentenceOrderReading,
  readingSpeedCheck,
  guessTitle,
  readAndMatch,
  paragraphSummary,
  readingInference,
  readingConclusion,
  // 4. Writing
  sentenceBuilder,
  completeSentence,
  describeSituationWriting,
  fixTheSentence,
  shortAnswerWriting,
  opinionWriting,
  dailyJournal,
  summarizeStoryWriting,
  writingEmail,
  correctionWriting,
  essayDrafting,
  // 5. Grammar
  grammarQuest,
  sentenceCorrection,
  wordReorder,
  tenseMastery,
  partsOfSpeech,
  subjectVerbAgreement,
  clauseConnector,
  voiceSwap,
  questionFormatter,
  articleInsertion,
  // 6. Vocabulary
  flashcards,
  synonymSearch,
  antonymSearch,
  contextClues,
  phrasalVerbs,
  idioms,
  academicWord,
  topicVocab,
  wordFormation,
  prefixSuffix,
  // 7. Accent
  minimalPairs,
  intonationMimic,
  syllableStress,
  wordLinking,
  shadowingChallenge,
  vowelDistinction,
  consonantClarity,
  pitchPatternMatch,
  speedVariance,
  dialectDrill,
  // 8. Roleplay
  branchingDialogue,
  situationalResponse,
  jobInterview,
  medicalConsult,
  gourmetOrder,
  travelDesk,
  conflictResolver,
  elevatorPitch,
  socialSpark,
  emergencyHub,
}

enum QuestType {
  speaking,
  listening,
  reading,
  writing,
  grammar,
  vocabulary,
  accent,
  roleplay,
}

extension GameSubtypeX on GameSubtype {
  QuestType get category {
    if (index >= 0 && index <= 9) return QuestType.speaking;
    if (index >= 10 && index <= 19) return QuestType.listening;
    if (index >= 20 && index <= 29) return QuestType.reading;
    if (index >= 30 && index <= 40) return QuestType.writing;
    if (index >= 41 && index <= 50) return QuestType.grammar;
    if (index >= 51 && index <= 60) return QuestType.vocabulary;
    if (index >= 61 && index <= 70) return QuestType.accent;
    return QuestType.roleplay;
  }

  bool get isLegacy => false;
}

extension QuestTypeX on QuestType {
  List<GameSubtype> get subtypes {
    switch (this) {
      case QuestType.speaking:
        return GameSubtype.values.sublist(0, 10);
      case QuestType.listening:
        return GameSubtype.values.sublist(10, 20);
      case QuestType.reading:
        return GameSubtype.values.sublist(20, 30);
      case QuestType.writing:
        return GameSubtype.values.sublist(30, 41);
      case QuestType.grammar:
        return GameSubtype.values.sublist(41, 51);
      case QuestType.vocabulary:
        return GameSubtype.values.sublist(51, 61);
      case QuestType.accent:
        return GameSubtype.values.sublist(61, 71);
      case QuestType.roleplay:
        return GameSubtype.values.sublist(71, 81);
    }
  }

  String get name {
    switch (this) {
      case QuestType.speaking:
        return 'speaking';
      case QuestType.listening:
        return 'listening';
      case QuestType.reading:
        return 'reading';
      case QuestType.writing:
        return 'writing';
      case QuestType.grammar:
        return 'grammar';
      case QuestType.vocabulary:
        return 'vocabulary';
      case QuestType.accent:
        return 'accent';
      case QuestType.roleplay:
        return 'roleplay';
    }
  }
}

class GameQuest extends Equatable {
  final String id;
  final QuestType? type;
  final String instruction;
  final int difficulty;
  final GameSubtype? subtype;
  final InteractionType interactionType;
  final int xpReward;
  final int coinReward;
  final int livesAllowed;
  final List<String>? options;
  final int? correctAnswerIndex;
  final String? correctAnswer;
  final String? hint;
  final String? textToSpeak;

  const GameQuest({
    required this.id,
    this.type,
    required this.instruction,
    required this.difficulty,
    this.subtype,
    this.interactionType = InteractionType.choice,
    this.xpReward = 10,
    this.coinReward = 10,
    this.livesAllowed = 3,
    this.options,
    this.correctAnswerIndex,
    this.correctAnswer,
    this.hint,
    this.textToSpeak,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    instruction,
    difficulty,
    subtype,
    interactionType,
    xpReward,
    coinReward,
    livesAllowed,
    options,
    correctAnswerIndex,
    correctAnswer,
    hint,
    textToSpeak,
  ];
}
