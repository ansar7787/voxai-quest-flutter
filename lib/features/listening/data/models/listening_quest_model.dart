import '../../domain/entities/listening_quest.dart';
import '../../../../core/domain/entities/game_quest.dart';

class ListeningQuestModel extends ListeningQuest {
  const ListeningQuestModel({
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
    super.audioUrl,
    super.question,
    super.statement,
    super.textWithBlanks,
    super.audioOptions,
    super.transcript,
    super.targetEmotion,
    super.textToSpeak,
  });

  factory ListeningQuestModel.fromJson(Map<String, dynamic> map, String id) {
    final subtype = GameSubtype.values.firstWhere(
      (s) => s.name == map['subtype'],
      orElse: () => GameSubtype.audioFillBlanks,
    );
    return ListeningQuestModel(
      id: id,
      type: subtype.category,
      subtype: subtype,
      instruction: map['instruction'] ?? 'Listen and answer.',
      difficulty: map['difficulty'] ?? 1,
      interactionType: InteractionType.values.firstWhere(
        (i) => i.name == (map['interactionType'] ?? 'choice'),
        orElse: () => InteractionType.choice,
      ),
      xpReward: map['xpReward'] ?? 10,
      coinReward: map['coinReward'] ?? 5,
      livesAllowed: map['livesAllowed'],
      options: map['options'] != null
          ? List<String>.from(map['options'])
          : null,
      correctAnswerIndex:
          map['correctAnswerIndex'] ?? map['correctAnswerIndex'],
      correctAnswer: map['correctAnswer'],
      hint: map['hint'],
      audioUrl: map['audioUrl'],
      question: map['question'],
      statement: map['statement'],
      textWithBlanks: map['textWithBlanks'],
      audioOptions: map['audioOptions'] != null
          ? List<String>.from(map['audioOptions'])
          : null,
      transcript: map['transcript'] as String?,
      targetEmotion: map['targetEmotion'],
      textToSpeak: map['textToSpeak'] as String?,
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
      'audioUrl': audioUrl,
      'question': question,
      'statement': statement,
      'textWithBlanks': textWithBlanks,
      'audioOptions': audioOptions,
      'transcript': transcript,
      'targetEmotion': targetEmotion,
    };
  }
}
