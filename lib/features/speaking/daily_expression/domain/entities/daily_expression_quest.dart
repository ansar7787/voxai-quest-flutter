import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class DailyExpressionQuest extends GameQuest {
  final String? expression;
  final String? meaning;
  final String? context;
  final String? audioUrl;
  final String? translation;

  const DailyExpressionQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.speech,
    this.expression,
    this.meaning,
    this.context,
    this.audioUrl,
    this.translation,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    expression,
    meaning,
    context,
    audioUrl,
    translation,
  ];
}
