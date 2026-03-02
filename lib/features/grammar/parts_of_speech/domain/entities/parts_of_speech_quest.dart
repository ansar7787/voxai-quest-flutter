import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class PartsOfSpeechQuest extends GameQuest {
  final String? sentence;
  final String? targetWord;
  final String? category;

  const PartsOfSpeechQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.text,
    super.options,
    super.correctAnswerIndex,
    super.correctAnswer,
    super.hint,
    this.sentence,
    this.targetWord,
    this.category,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        sentence,
        targetWord,
        category,
      ];
}
