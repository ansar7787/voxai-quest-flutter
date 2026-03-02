import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class GuessTitleQuest extends GameQuest {
  final String? passage;

  const GuessTitleQuest({
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
    this.passage,
  });

  @override
  List<Object?> get props => [...super.props, passage];
}
