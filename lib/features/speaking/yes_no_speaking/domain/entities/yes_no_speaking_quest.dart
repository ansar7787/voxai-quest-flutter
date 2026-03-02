import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class YesNoSpeakingQuest extends GameQuest {
  final String? questionContent;
  final bool? isYesAnswer;
  final String? translation;

  const YesNoSpeakingQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.speech,
    this.questionContent,
    this.isYesAnswer,
    this.translation,
  });

  @override
  String? get correctAnswer => isYesAnswer?.toString();

  @override
  List<Object?> get props => [
    ...super.props,
    questionContent,
    isYesAnswer,
    translation,
  ];
}
