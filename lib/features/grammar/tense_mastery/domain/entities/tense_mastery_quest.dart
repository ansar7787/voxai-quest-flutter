import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class TenseMasteryQuest extends GameQuest {
  final String? sentenceWithBlank;
  final String? verb;
  final String? targetTense;

  const TenseMasteryQuest({
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
    this.sentenceWithBlank,
    this.verb,
    this.targetTense,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    sentenceWithBlank,
    verb,
    targetTense,
  ];
}
