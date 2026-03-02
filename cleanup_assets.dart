import 'package:flutter/foundation.dart';
import 'dart:io';

void main() async {
  final Map<String, List<List<String>>> gameMap = {
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

  final String basePath = 'assets/curriculum';
  int deletedCount = 0;

  for (var entry in gameMap.entries) {
    final category = entry.key;
    final games = entry.value;

    for (var game in games) {
      final prefix = game[0];

      for (int s = 1; s <= 7; s++) {
        final filePath = '$basePath/$category/${prefix}_s$s.json';
        final file = File(filePath);

        if (await file.exists()) {
          try {
            await file.delete();
            debugPrint('Deleted $filePath');
            deletedCount++;
          } catch (e) {
            debugPrint('Error deleting $filePath: $e');
          }
        }
      }
    }
  }

  debugPrint('Successfully deleted $deletedCount legacy section files.');
}
