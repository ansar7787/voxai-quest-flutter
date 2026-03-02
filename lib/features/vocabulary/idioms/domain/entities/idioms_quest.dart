import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class IdiomsQuest extends GameQuest {
  final String? idiom;
  final String? meaning;
  final String? example;

  const IdiomsQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.choice,
    super.options,
    super.correctAnswerIndex,
    super.correctAnswer,
    super.hint,
    this.idiom,
    this.meaning,
    this.example,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        idiom,
        meaning,
        example,
      ];
}
