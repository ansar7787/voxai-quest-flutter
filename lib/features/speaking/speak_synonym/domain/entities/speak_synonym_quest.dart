import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class SpeakSynonymQuest extends GameQuest {
  final String? word;
  final List<String>? synonyms;
  final String? translation;

  const SpeakSynonymQuest({
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
    this.synonyms,
    this.translation,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        word,
        synonyms,
        translation,
      ];
}
