import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class OpinionWritingQuest extends GameQuest {
  final String? topic;
  final List<String>? viewpoints;

  const OpinionWritingQuest({
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
    this.topic,
    this.viewpoints,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        topic,
        viewpoints,
      ];
}
