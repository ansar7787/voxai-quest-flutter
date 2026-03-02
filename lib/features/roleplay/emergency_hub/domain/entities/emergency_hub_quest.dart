import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class EmergencyHubQuest extends GameQuest {
  final String? emergencyType;
  final String? urgencyLevel;
  final List<String>? requiredActions;
  final String? callerState;
  final String? dispatcherFeedback;

  const EmergencyHubQuest({
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
    this.emergencyType,
    this.urgencyLevel,
    this.requiredActions,
    this.callerState,
    this.dispatcherFeedback,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        emergencyType,
        urgencyLevel,
        requiredActions,
        callerState,
        dispatcherFeedback,
      ];
}
