import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class SituationSpeakingQuest extends GameQuest {
  final String? situationText;
  final String? sampleAnswer;
  final String? translation;

  const SituationSpeakingQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.speech,
    this.situationText,
    this.sampleAnswer,
    this.translation,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    situationText,
    sampleAnswer,
    translation,
  ];
}
