import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class DescribeSituationWritingQuest extends GameQuest {
  final String? situationContext;
  final List<String>? requiredDetails;
  final String? imagePath;

  const DescribeSituationWritingQuest({
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
    this.situationContext,
    this.requiredDetails,
    this.imagePath,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    situationContext,
    requiredDetails,
    imagePath,
  ];
}
