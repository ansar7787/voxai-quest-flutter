import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class WritingEmailQuest extends GameQuest {
  final String? scenario;
  final String? recipient;
  final String? subject;
  final List<String>? requiredPoints;

  const WritingEmailQuest({
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
    this.scenario,
    this.recipient,
    this.subject,
    this.requiredPoints,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    scenario,
    recipient,
    subject,
    requiredPoints,
  ];
}
