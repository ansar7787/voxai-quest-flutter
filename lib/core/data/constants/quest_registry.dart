class QuestRegistry {
  /// Maps each gameType to its corresponding category (skill) folder in assets/curriculum.
  static const Map<String, String> gameToCategory = {
    // Accent
    'consonantClarity': 'accent',
    'dialectDrill': 'accent',
    'intonationMimic': 'accent',
    'minimalPairs': 'accent',
    'pitchPatternMatch': 'accent',
    'shadowingChallenge': 'accent',
    'speedVariance': 'accent',
    'syllableStress': 'accent',
    'vowelDistinction': 'accent',
    'wordLinking': 'accent',

    // Grammar
    'articleInsertion': 'grammar',
    'clauseConnector': 'grammar',
    'grammarQuest': 'grammar',
    'partsOfSpeech': 'grammar',
    'questionFormatter': 'grammar',
    'sentenceCorrection': 'grammar',
    'subjectVerbAgreement': 'grammar',
    'tenseMastery': 'grammar',
    'voiceSwap': 'grammar',
    'wordReorder': 'grammar',

    // Listening
    'ambientId': 'listening',
    'audioFillBlanks': 'listening',
    'audioMultipleChoice': 'listening',
    'audioSentenceOrder': 'listening',
    'audioTrueFalse': 'listening',
    'detailSpotlight': 'listening',
    'emotionRecognition': 'listening',
    'fastSpeechDecoder': 'listening',
    'listeningInference': 'listening',
    'soundImageMatch': 'listening',

    // Reading
    'findWordMeaning': 'reading',
    'guessTitle': 'reading',
    'paragraphSummary': 'reading',
    'readAndAnswer': 'reading',
    'readAndMatch': 'reading',
    'readingConclusion': 'reading',
    'readingInference': 'reading',
    'readingSpeedCheck': 'reading',
    'sentenceOrderReading': 'reading',
    'trueFalseReading': 'reading',

    // Roleplay
    'branchingDialogue': 'roleplay',
    'conflictResolver': 'roleplay',
    'elevatorPitch': 'roleplay',
    'emergencyHub': 'roleplay',
    'gourmetOrder': 'roleplay',
    'jobInterview': 'roleplay',
    'medicalConsult': 'roleplay',
    'situationalResponse': 'roleplay',
    'socialSpark': 'roleplay',
    'travelDesk': 'roleplay',

    // Speaking
    'dailyExpression': 'speaking',
    'dialogueRoleplay': 'speaking',
    'pronunciationFocus': 'speaking',
    'repeatSentence': 'speaking',
    'sceneDescriptionSpeaking': 'speaking',
    'situationSpeaking': 'speaking',
    'speakMissingWord': 'speaking',
    'speakOpposite': 'speaking',
    'speakSynonym': 'speaking',
    'yesNoSpeaking': 'speaking',

    // Vocabulary
    'academicWord': 'vocabulary',
    'antonymSearch': 'vocabulary',
    'contextClues': 'vocabulary',
    'flashcards': 'vocabulary',
    'idioms': 'vocabulary',
    'phrasalVerbs': 'vocabulary',
    'prefixSuffix': 'vocabulary',
    'synonymSearch': 'vocabulary',
    'topicVocab': 'vocabulary',
    'wordFormation': 'vocabulary',

    // Writing
    'completeSentence': 'writing',
    'correctionWriting': 'writing',
    'dailyJournal': 'writing',
    'describeSituationWriting': 'writing',
    'essayDrafting': 'writing',
    'fixTheSentence': 'writing',
    'opinionWriting': 'writing',
    'sentenceBuilder': 'writing',
    'shortAnswerWriting': 'writing',
    'summarizeStoryWriting': 'writing',
    'writingEmail': 'writing',
  };

  /// Gets the full asset path for a specific game and level batch.
  /// Batch size is 10 levels (30 questions) per file.
  static String getAssetPath(String gameType, int level) {
    final category = gameToCategory[gameType];
    if (category == null) throw Exception('Unknown gameType: $gameType');

    final batchIndex = ((level - 1) ~/ 10) + 1;
    final startLevel = (batchIndex - 1) * 10 + 1;
    final endLevel = batchIndex * 10;

    return 'assets/curriculum/$category/${gameType}_${startLevel}_$endLevel.json';
  }
}
