import '../../domain/entities/accent_quest.dart';
import '../../../../core/domain/entities/game_quest.dart';

class AccentQuestModel extends AccentQuest {
  const AccentQuestModel({
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
    super.audioUrl,
    super.words,
    super.intonationMap,
    super.syllables,
    super.targetSpeed,
  });

  factory AccentQuestModel.fromJson(Map<String, dynamic> map, String id) {
    final subtype = GameSubtype.values.firstWhere(
      (s) => s.name == map['subtype'],
      orElse: () => GameSubtype.minimalPairs,
    );
    return AccentQuestModel(
      id: id,
      type: subtype.category,
      subtype: subtype,
      instruction: map['instruction'] ?? 'Mimic the accent.',
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
      audioUrl: map['audioUrl'],
      words: map['words'] != null ? List<String>.from(map['words']) : null,
      intonationMap: map['intonationMap'] != null
          ? List<int>.from(map['intonationMap'])
          : null,
      syllables: map['syllables'] != null
          ? List<String>.from(map['syllables'])
          : null,
      targetSpeed: (map['targetSpeed'] as num?)?.toDouble(),
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
      'words': words,
      'intonationMap': intonationMap,
      'syllables': syllables,
      'targetSpeed': targetSpeed,
    };
  }
}
