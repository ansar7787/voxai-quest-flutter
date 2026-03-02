import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class RepeatSentenceQuest extends GameQuest {
  final String? translation;

  const RepeatSentenceQuest({
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
    this.translation,
  });

  @override
  List<Object?> get props => [...super.props, textToSpeak, translation];
}
