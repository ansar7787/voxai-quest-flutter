import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class SceneDescriptionSpeakingQuest extends GameQuest {
  final String? sceneText;
  final List<String>? keywords;
  final String? translation;

  const SceneDescriptionSpeakingQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.speech,
    this.sceneText,
    this.keywords,
    this.translation,
  });

  @override
  List<Object?> get props => [...super.props, sceneText, keywords, translation];
}
