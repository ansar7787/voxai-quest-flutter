import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class SocialSparkQuest extends GameQuest {
  final String? setting;
  final String? socialContext;
  final String? conversationStarter;
  final List<String>? conversationalHooks;
  final String? closure;

  const SocialSparkQuest({
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
    this.setting,
    this.socialContext,
    this.conversationStarter,
    this.conversationalHooks,
    this.closure,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        setting,
        socialContext,
        conversationStarter,
        conversationalHooks,
        closure,
      ];
}
