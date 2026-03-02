import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class SpeakOppositeQuest extends GameQuest {
  final String? word;
  final String? phoneticScript;
  final String? audioUrl;
  final String? oppositeWord;
  final String? translation;

  const SpeakOppositeQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.speech,
    this.word,
    this.phoneticScript,
    this.audioUrl,
    this.oppositeWord,
    this.translation,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    word,
    phoneticScript,
    audioUrl,
    oppositeWord,
    translation,
  ];
}
