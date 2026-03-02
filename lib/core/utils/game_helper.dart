import 'package:flutter/material.dart';
import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/core/presentation/themes/level_theme_helper.dart';

class GameHelper {
  static String getCategoryForSubtype(GameSubtype subtype) {
    return subtype.category.name;
  }

  static IconData getIconForCategory(QuestType type) {
    switch (type) {
      case QuestType.speaking:
        return Icons.mic_rounded;
      case QuestType.reading:
        return Icons.menu_book_rounded;
      case QuestType.writing:
        return Icons.edit_note_rounded;
      case QuestType.grammar:
        return Icons.spellcheck_rounded;
      case QuestType.listening:
        return Icons.headphones_rounded;
      case QuestType.accent:
        return Icons.graphic_eq_rounded;
      case QuestType.roleplay:
        return Icons.people_rounded;
      case QuestType.vocabulary:
        return Icons.menu_book_rounded;
    }
  }

  static GameMetadata getGameMetadata(
    GameSubtype subtype, {
    bool isDark = true,
  }) {
    final theme = LevelThemeHelper.getTheme(subtype.name, isDark: isDark);
    return GameMetadata(
      title: theme.title,
      color: theme.primaryColor,
      categoryName: getCategoryForSubtype(subtype).toUpperCase(),
      icon: getIconForSubtype(subtype),
    );
  }

  static IconData getIconForSubtype(GameSubtype subtype) {
    switch (subtype) {
      case GameSubtype.repeatSentence:
        return Icons.repeat_rounded;
      case GameSubtype.speakMissingWord:
        return Icons.add_comment_rounded;
      case GameSubtype.situationSpeaking:
        return Icons.landscape_rounded;
      case GameSubtype.sceneDescriptionSpeaking:
        return Icons.image_search_rounded;
      case GameSubtype.yesNoSpeaking:
        return Icons.thumbs_up_down_rounded;
      case GameSubtype.speakSynonym:
        return Icons.compare_arrows_rounded;
      case GameSubtype.dialogueRoleplay:
        return Icons.forum_rounded;
      case GameSubtype.pronunciationFocus:
        return Icons.record_voice_over_rounded;
      case GameSubtype.speakOpposite:
        return Icons.swap_horiz_rounded;
      case GameSubtype.dailyExpression:
        return Icons.auto_awesome_rounded;
      case GameSubtype.readAndAnswer:
        return Icons.question_answer_rounded;
      case GameSubtype.findWordMeaning:
        return Icons.manage_search_rounded;
      case GameSubtype.trueFalseReading:
        return Icons.fact_check_rounded;
      case GameSubtype.sentenceOrderReading:
        return Icons.low_priority_rounded;
      case GameSubtype.readingSpeedCheck:
        return Icons.speed_rounded;
      case GameSubtype.guessTitle:
        return Icons.title_rounded;
      case GameSubtype.readAndMatch:
        return Icons.handshake_rounded;
      case GameSubtype.paragraphSummary:
        return Icons.summarize_rounded;
      case GameSubtype.sentenceBuilder:
        return Icons.build_circle_rounded;
      case GameSubtype.completeSentence:
        return Icons.check_circle_rounded;
      case GameSubtype.describeSituationWriting:
        return Icons.description_rounded;
      case GameSubtype.fixTheSentence:
        return Icons.healing_rounded;
      case GameSubtype.shortAnswerWriting:
        return Icons.short_text_rounded;
      case GameSubtype.opinionWriting:
        return Icons.rate_review_rounded;
      case GameSubtype.dailyJournal:
        return Icons.history_edu_rounded;
      case GameSubtype.grammarQuest:
        return Icons.extension_rounded;
      case GameSubtype.sentenceCorrection:
        return Icons.spellcheck_rounded;
      case GameSubtype.wordReorder:
        return Icons.reorder_rounded;
      case GameSubtype.tenseMastery:
        return Icons.history_rounded;
      case GameSubtype.partsOfSpeech:
        return Icons.category_outlined;
      case GameSubtype.subjectVerbAgreement:
        return Icons.link_rounded;
      case GameSubtype.audioFillBlanks:
        return Icons.headphones_rounded;
      case GameSubtype.audioMultipleChoice:
        return Icons.list_alt_rounded;
      case GameSubtype.minimalPairs:
        return Icons.hearing_rounded;
      case GameSubtype.intonationMimic:
        return Icons.keyboard_voice_rounded;
      case GameSubtype.branchingDialogue:
        return Icons.fork_right_rounded;
      case GameSubtype.situationalResponse:
        return Icons.question_answer_rounded;
      case GameSubtype.synonymSearch:
        return Icons.sync_rounded;
      case GameSubtype.antonymSearch:
        return Icons.compare_rounded;
      case GameSubtype.idioms:
        return Icons.lightbulb_rounded;
      case GameSubtype.contextClues:
        return Icons.help_outline_rounded;
      case GameSubtype.phrasalVerbs:
        return Icons.link_rounded;
      case GameSubtype.academicWord:
        return Icons.text_fields_rounded;
      case GameSubtype.readingInference:
        return Icons.psychology_rounded;
      case GameSubtype.readingConclusion:
        return Icons.auto_stories_rounded;
      case GameSubtype.summarizeStoryWriting:
        return Icons.auto_awesome_motion_rounded;
      case GameSubtype.writingEmail:
        return Icons.mail_lock_rounded;
      case GameSubtype.correctionWriting:
        return Icons.edit_calendar_rounded;
      case GameSubtype.flashcards:
        return Icons.style_rounded;
      case GameSubtype.topicVocab:
        return Icons.category_rounded;
      case GameSubtype.wordFormation:
        return Icons.build_circle_outlined;
      case GameSubtype.prefixSuffix:
        return Icons.wrap_text_rounded;
      // New Accent Games
      case GameSubtype.syllableStress:
        return Icons.center_focus_strong_rounded;
      case GameSubtype.wordLinking:
        return Icons.link_rounded;
      case GameSubtype.shadowingChallenge:
        return Icons.record_voice_over_rounded;
      case GameSubtype.vowelDistinction:
        return Icons.record_voice_over_outlined;
      case GameSubtype.consonantClarity:
        return Icons.mic_external_on_rounded;
      case GameSubtype.pitchPatternMatch:
        return Icons.water_drop_rounded;
      case GameSubtype.speedVariance:
        return Icons.speed_rounded;
      case GameSubtype.dialectDrill:
        return Icons.language_rounded;
      // New Roleplay Games
      case GameSubtype.jobInterview:
        return Icons.work_rounded;
      case GameSubtype.medicalConsult:
        return Icons.medical_services_rounded;
      case GameSubtype.gourmetOrder:
        return Icons.restaurant_rounded;
      case GameSubtype.travelDesk:
        return Icons.travel_explore_rounded;
      case GameSubtype.conflictResolver:
        return Icons.handshake_rounded;
      case GameSubtype.elevatorPitch:
        return Icons.trending_up_rounded;
      case GameSubtype.socialSpark:
        return Icons.celebration_rounded;
      case GameSubtype.emergencyHub:
        return Icons.emergency_rounded;
      // New Listening Games
      case GameSubtype.audioSentenceOrder:
        return Icons.low_priority_rounded;
      case GameSubtype.audioTrueFalse:
        return Icons.rule_rounded;
      case GameSubtype.soundImageMatch:
        return Icons.image_search_rounded;
      case GameSubtype.fastSpeechDecoder:
        return Icons.fast_forward_rounded;
      case GameSubtype.emotionRecognition:
        return Icons.emoji_emotions_rounded;
      case GameSubtype.detailSpotlight:
        return Icons.center_focus_weak_rounded;
      case GameSubtype.listeningInference:
        return Icons.psychology_alt_rounded;
      case GameSubtype.ambientId:
        return Icons.surround_sound_rounded;
      // New Grammar Games
      case GameSubtype.clauseConnector:
        return Icons.join_left_rounded;
      case GameSubtype.voiceSwap:
        return Icons.swap_calls_rounded;
      case GameSubtype.questionFormatter:
        return Icons.help_center_rounded;
      case GameSubtype.articleInsertion:
        return Icons.add_circle_rounded;
      case GameSubtype.essayDrafting:
        return Icons.history_edu_rounded;
    }
  }
}

class GameMetadata {
  final String title;
  final IconData icon;
  final Color color;
  final String categoryName;

  GameMetadata({
    required this.title,
    required this.icon,
    required this.color,
    required this.categoryName,
  });
}
