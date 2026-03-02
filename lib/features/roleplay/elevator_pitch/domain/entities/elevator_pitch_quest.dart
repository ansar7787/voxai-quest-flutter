import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class ElevatorPitchQuest extends GameQuest {
  final String? investorProfile;
  final String? productDescription;
  final String? timeLimit;
  final List<String>? keySellingPoints;
  final String? feedback;

  const ElevatorPitchQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType,
    super.options,
    super.correctAnswerIndex,
    this.investorProfile,
    this.productDescription,
    this.timeLimit,
    this.keySellingPoints,
    this.feedback,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    investorProfile,
    productDescription,
    timeLimit,
    keySellingPoints,
    feedback,
  ];
}
