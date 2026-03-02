import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class SpeakMissingWordQuest extends GameQuest {
  final String? missingWord;
  final String? translation;

  const SpeakMissingWordQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.speech,
    super.textToSpeak,
    this.missingWord,
    this.translation,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    textToSpeak,
    missingWord,
    translation,
  ];
}
