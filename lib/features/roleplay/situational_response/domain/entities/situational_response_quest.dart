import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class SituationalResponseQuest extends GameQuest {
  final String? situation;
  final List<String>? keywords;
  final String? sampleAnswer;

  const SituationalResponseQuest({
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
    this.situation,
    this.keywords,
    this.sampleAnswer,
  });

  String? get npcLine => situation;

  @override
  List<Object?> get props => [
        ...super.props,
        situation,
        keywords,
        sampleAnswer,
      ];
}
