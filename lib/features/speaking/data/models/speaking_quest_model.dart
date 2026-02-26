import '../../domain/entities/speaking_quest.dart';
import '../../../../core/domain/entities/game_quest.dart';

class SpeakingQuestModel extends SpeakingQuest {
  const SpeakingQuestModel({
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
    super.textToSpeak,
    super.situationText,
    super.sceneText,
    super.acceptedSynonyms,
    super.phoneticHint,
    super.meaning,
    super.sampleUsage,
    super.missingWord,
  });

  factory SpeakingQuestModel.fromJson(Map<String, dynamic> map, String id) {
    final subtype = GameSubtype.values.firstWhere(
      (s) => s.name == map['subtype'],
      orElse: () => GameSubtype.repeatSentence,
    );
    return SpeakingQuestModel(
      id: id,
      type: subtype.category,
      subtype: subtype,
      instruction: map['instruction'] ?? 'Speak the words.',
      difficulty: map['difficulty'] ?? 1,
      interactionType: InteractionType.values.firstWhere(
        (i) => i.name == (map['interactionType'] ?? 'speech'),
        orElse: () => InteractionType.speech,
      ),
      xpReward: map['xpReward'] ?? 10,
      coinReward: map['coinReward'] ?? 5,
      livesAllowed: map['livesAllowed'],
      options: map['options'] != null
          ? List<String>.from(map['options'])
          : null,
      correctAnswerIndex: map['correctAnswerIndex'],
      correctAnswer: map['correctAnswer'],
      hint: map['hint'],
      textToSpeak: map['textToSpeak'],
      situationText: map['situationText'],
      sceneText: map['sceneText'],
      acceptedSynonyms: map['acceptedSynonyms'] != null
          ? List<String>.from(map['acceptedSynonyms'])
          : null,
      phoneticHint: map['phoneticHint'],
      meaning: map['meaning'],
      sampleUsage: map['sampleUsage'],
      missingWord: map['missingWord'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'instruction': instruction,
      'difficulty': difficulty,
      'subtype': subtype?.name,
      'interactionType': interactionType.name,
      'xpReward': xpReward,
      'coinReward': coinReward,
      'livesAllowed': livesAllowed,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'correctAnswer': correctAnswer,
      'hint': hint,
      'textToSpeak': textToSpeak,
      'situationText': situationText,
      'sceneText': sceneText,
      'acceptedSynonyms': acceptedSynonyms,
      'phoneticHint': phoneticHint,
      'meaning': meaning,
      'sampleUsage': sampleUsage,
      'missingWord': missingWord,
    };
  }
}
