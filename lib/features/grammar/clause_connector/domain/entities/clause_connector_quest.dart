import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class ClauseConnectorQuest extends GameQuest {
  final String? firstClause;
  final String? secondClause;
  final String? connectorToUse;

  const ClauseConnectorQuest({
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
    this.firstClause,
    this.secondClause,
    this.connectorToUse,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        firstClause,
        secondClause,
        connectorToUse,
      ];
}
