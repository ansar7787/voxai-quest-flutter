import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Reads curriculum JSON files from local assets and uploads them to Firestore.
///
/// Firestore structure: quests/{subtypeName}/levels/{levelNumber}
/// Each level doc: { id, levelNumber, skill, gameType, quests: [...], updatedAt }
class CurriculumUploadService {
  final FirebaseFirestore _firestore;

  CurriculumUploadService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // ─── 80 Game Mappings ───────────────────────────────────────────────────
  // Maps: category folder → [ (file_prefix, GameSubtype enum name) ]
  static const Map<String, List<List<String>>> _gameMap = {
    'speaking': [
      ['repeat_sentence', 'repeatSentence'],
      ['speak_missing_word', 'speakMissingWord'],
      ['situation_speaking', 'situationSpeaking'],
      ['scene_description_speaking', 'sceneDescriptionSpeaking'],
      ['yes_no_speaking', 'yesNoSpeaking'],
      ['speak_synonym', 'speakSynonym'],
      ['dialogue_roleplay', 'dialogueRoleplay'],
      ['pronunciation_focus', 'pronunciationFocus'],
      ['speak_opposite', 'speakOpposite'],
      ['daily_expression', 'dailyExpression'],
    ],
    'listening': [
      ['audio_fill_blanks', 'audioFillBlanks'],
      ['audio_multiple_choice', 'audioMultipleChoice'],
      ['audio_sentence_order', 'audioSentenceOrder'],
      ['audio_true_false', 'audioTrueFalse'],
      ['sound_image_match', 'soundImageMatch'],
      ['fast_speech_decoder', 'fastSpeechDecoder'],
      ['emotion_recognition', 'emotionRecognition'],
      ['detail_spotlight', 'detailSpotlight'],
      ['listening_inference', 'listeningInference'],
      ['ambient_id', 'ambientId'],
    ],
    'reading': [
      ['read_and_answer', 'readAndAnswer'],
      ['find_word_meaning', 'findWordMeaning'],
      ['true_false_reading', 'trueFalseReading'],
      ['sentence_order_reading', 'sentenceOrderReading'],
      ['reading_speed_check', 'readingSpeedCheck'],
      ['guess_title', 'guessTitle'],
      ['read_and_match', 'readAndMatch'],
      ['paragraph_summary', 'paragraphSummary'],
      ['reading_inference', 'readingInference'],
      ['reading_conclusion', 'readingConclusion'],
    ],
    'writing': [
      ['sentence_builder', 'sentenceBuilder'],
      ['complete_sentence', 'completeSentence'],
      ['describe_situation_writing', 'describeSituationWriting'],
      ['fix_the_sentence', 'fixTheSentence'],
      ['short_answer_writing', 'shortAnswerWriting'],
      ['opinion_writing', 'opinionWriting'],
      ['daily_journal', 'dailyJournal'],
      ['summarize_story_writing', 'summarizeStoryWriting'],
      ['writing_email', 'writingEmail'],
      ['correction_writing', 'correctionWriting'],
      ['essay_drafting', 'essayDrafting'],
    ],
    'grammar': [
      ['grammar_quest', 'grammarQuest'],
      ['sentence_correction', 'sentenceCorrection'],
      ['word_reorder', 'wordReorder'],
      ['tense_mastery', 'tenseMastery'],
      ['parts_of_speech', 'partsOfSpeech'],
      ['subject_verb_agreement', 'subjectVerbAgreement'],
      ['clause_connector', 'clauseConnector'],
      ['voice_swap', 'voiceSwap'],
      ['question_formatter', 'questionFormatter'],
      ['article_insertion', 'articleInsertion'],
    ],
    'vocabulary': [
      ['flashcards', 'flashcards'],
      ['synonym_search', 'synonymSearch'],
      ['antonym_search', 'antonymSearch'],
      ['context_clues', 'contextClues'],
      ['phrasal_verbs', 'phrasalVerbs'],
      ['idioms', 'idioms'],
      ['academic_word', 'academicWord'],
      ['topic_vocab', 'topicVocab'],
      ['word_formation', 'wordFormation'],
      ['prefix_suffix', 'prefixSuffix'],
    ],
    'accent': [
      ['minimal_pairs', 'minimalPairs'],
      ['intonation_mimic', 'intonationMimic'],
      ['syllable_stress', 'syllableStress'],
      ['word_linking', 'wordLinking'],
      ['shadowing_challenge', 'shadowingChallenge'],
      ['vowel_distinction', 'vowelDistinction'],
      ['consonant_clarity', 'consonantClarity'],
      ['pitch_pattern_match', 'pitchPatternMatch'],
      ['speed_variance', 'speedVariance'],
      ['dialect_drill', 'dialectDrill'],
    ],
    'roleplay': [
      ['branching_dialogue', 'branchingDialogue'],
      ['situational_response', 'situationalResponse'],
      ['job_interview', 'jobInterview'],
      ['medical_consult', 'medicalConsult'],
      ['gourmet_order', 'gourmetOrder'],
      ['travel_desk', 'travelDesk'],
      ['conflict_resolver', 'conflictResolver'],
      ['elevator_pitch', 'elevatorPitch'],
      ['social_spark', 'socialSpark'],
      ['emergency_hub', 'emergencyHub'],
    ],
  };

  // ─── Extract level number from quest ID ─────────────────────────────────
  // Generated IDs: "afb_L001_01" → level 1
  // Repeat sentence: "rs_a1_01_01" → level 1
  // Pattern: find the Lxxx part, or use positional fallback
  static int _extractLevel(String id) {
    // 1. Try L-prefix: afb_L001_01
    var match = RegExp(r'_L(\d+)_').firstMatch(id);
    if (match != null) return int.parse(match.group(1)!);

    // 2. Try s-prefix: ed_s1_q1 or rs_s1_01
    match = RegExp(r'_s(\d+)_').firstMatch(id);
    if (match != null) return int.parse(match.group(1)!);

    // 3. Fallback: split and look for numeric parts or s-prefix parts in segments
    final parts = id.split('_');
    for (var part in parts) {
      if (part.startsWith('s') || part.startsWith('L')) {
        final numPart = int.tryParse(part.substring(1));
        if (numPart != null) return numPart;
      }
      final directNum = int.tryParse(part);
      // Ignore high numbers (likely IDs) and focus on small numbers (levels)
      if (directNum != null && directNum < 300) return directNum;
    }

    return 1; // safe default
  }

  // ─── Upload a single game (7 section files) ────────────────────────────
  /// Reads all 7 section files for a game, groups quests by level,
  /// and uploads each level as a Firestore document.
  Future<Map<String, dynamic>> uploadSingleGame({
    required String category,
    required String filePrefix,
    required String subtypeName,
    void Function(int section, int totalQuests)? onProgress,
  }) async {
    final List<Map<String, dynamic>> allQuests = [];
    String? errorMessage;

    try {
      final path = 'assets/curriculum/$category/$filePrefix.json';
      final jsonString = await rootBundle.loadString(path);
      final parsed = jsonDecode(jsonString) as Map<String, dynamic>;
      final quests = (parsed['quests'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      allQuests.addAll(quests);
      onProgress?.call(1, allQuests.length);
    } catch (e) {
      errorMessage = 'Error loading $filePrefix.json: $e';
    }

    if (allQuests.isEmpty) {
      return {
        'success': false,
        'message': '❌ No quests loaded for $subtypeName',
        'errors': errorMessage != null ? [errorMessage] : [],
      };
    }

    // Group quests by level number (extracted from ID)
    final Map<int, List<Map<String, dynamic>>> byLevel = {};
    for (var quest in allQuests) {
      final level = _extractLevel(quest['id'] as String? ?? '');
      byLevel.putIfAbsent(level, () => []).add(quest);
    }

    // Upload each level as a Firestore document
    int uploaded = 0;
    for (final entry in byLevel.entries) {
      final levelNum = entry.key;
      final questsForLevel = entry.value;

      // Set difficulty on each quest to match its level number
      for (var q in questsForLevel) {
        q['difficulty'] = levelNum;
      }

      final levelData = {
        'id': 'level_$levelNum',
        'levelNumber': levelNum,
        'skill': category,
        'gameType': subtypeName,
        'quests': questsForLevel,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = _firestore
          .collection('quests')
          .doc(subtypeName)
          .collection('levels')
          .doc(levelNum.toString());

      await docRef.set(levelData, SetOptions(merge: true));
      uploaded++;
    }

    return {
      'success': errorMessage == null,
      'totalQuests': allQuests.length,
      'totalLevels': uploaded,
      'errors': errorMessage != null ? [errorMessage] : [],
      'message': errorMessage == null
          ? '✅ $subtypeName: ${allQuests.length} quests → $uploaded levels'
          : '⚠️ $subtypeName: $uploaded levels, error: $errorMessage',
    };
  }

  // ─── Upload all games in a category ─────────────────────────────────────
  Future<Map<String, dynamic>> uploadCategory({
    required String category,
    void Function(String game, int gameIndex, int totalQuests)? onProgress,
  }) async {
    final games = _gameMap[category];
    if (games == null) {
      return {'success': false, 'message': '❌ Unknown category: $category'};
    }

    int totalQuests = 0;
    int totalLevels = 0;
    int totalErrors = 0;
    final List<String> errorDetails = [];

    for (int i = 0; i < games.length; i++) {
      final filePrefix = games[i][0];
      final subtypeName = games[i][1];
      onProgress?.call(subtypeName, i, totalQuests);

      final result = await uploadSingleGame(
        category: category,
        filePrefix: filePrefix,
        subtypeName: subtypeName,
      );

      totalQuests += (result['totalQuests'] as int?) ?? 0;
      totalLevels += (result['totalLevels'] as int?) ?? 0;
      if (result['errors'] is List) {
        final errs = result['errors'] as List;
        totalErrors += errs.length;
        errorDetails.addAll(errs.cast<String>());
      }
    }

    return {
      'success': totalErrors == 0,
      'totalQuests': totalQuests,
      'totalLevels': totalLevels,
      'totalErrors': totalErrors,
      'errors': errorDetails,
      'message': totalErrors == 0
          ? '✅ $category: $totalQuests quests → $totalLevels levels (${games.length} games)'
          : '⚠️ $category: $totalLevels levels, $totalErrors errors',
    };
  }

  // ─── Upload ALL 80 games ────────────────────────────────────────────────
  Future<Map<String, dynamic>> uploadAll({
    void Function(
      String category,
      String game,
      int gamesCompleted,
      int totalGames,
      int totalQuests,
    )?
    onProgress,
  }) async {
    int totalQuests = 0;
    int totalLevels = 0;
    int totalErrors = 0;
    int gamesCompleted = 0;
    const totalGames = 80;
    final List<String> errorDetails = [];

    for (final category in _gameMap.keys) {
      final games = _gameMap[category]!;
      for (final game in games) {
        final filePrefix = game[0];
        final subtypeName = game[1];
        onProgress?.call(
          category,
          subtypeName,
          gamesCompleted,
          totalGames,
          totalQuests,
        );

        final result = await uploadSingleGame(
          category: category,
          filePrefix: filePrefix,
          subtypeName: subtypeName,
        );

        totalQuests += (result['totalQuests'] as int?) ?? 0;
        totalLevels += (result['totalLevels'] as int?) ?? 0;
        if (result['errors'] is List) {
          final errs = result['errors'] as List;
          totalErrors += errs.length;
          errorDetails.addAll(errs.cast<String>());
        }
        gamesCompleted++;
      }
    }

    return {
      'success': totalErrors == 0,
      'totalQuests': totalQuests,
      'totalLevels': totalLevels,
      'totalGames': gamesCompleted,
      'totalErrors': totalErrors,
      'errors': errorDetails,
      'message': totalErrors == 0
          ? '🚀 ALL DONE: $totalQuests quests → $totalLevels levels ($gamesCompleted games)'
          : '⚠️ $totalLevels levels uploaded, $totalErrors errors across $gamesCompleted games',
    };
  }

  // ─── Check upload stats for a game ──────────────────────────────────────
  Future<Map<String, int>> getUploadStats(String subtypeName) async {
    final snapshot = await _firestore
        .collection('quests')
        .doc(subtypeName)
        .collection('levels')
        .get();

    int totalQuests = 0;
    for (var doc in snapshot.docs) {
      final quests = doc.data()['quests'];
      if (quests is List) totalQuests += quests.length;
    }

    return {'levelCount': snapshot.docs.length, 'questCount': totalQuests};
  }

  // ─── Get category and file prefix for a GameSubtype ─────────────────────
  static (String category, String filePrefix)? getGameInfo(String subtypeName) {
    for (final entry in _gameMap.entries) {
      for (final game in entry.value) {
        if (game[1] == subtypeName) {
          return (entry.key, game[0]);
        }
      }
    }
    return null;
  }

  /// All 8 categories
  static List<String> get categories => _gameMap.keys.toList();

  /// Games for a specific category: returns list of [filePrefix, subtypeName]
  static List<List<String>> gamesForCategory(String category) =>
      _gameMap[category] ?? [];
}
