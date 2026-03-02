import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class AudioSentenceOrderQuest extends GameQuest {
  final String? audioUrl;
  final List<String>? shuffledSentences;
  final List<int>? correctOrder;

  const AudioSentenceOrderQuest({
    required super.id,
    super.type = QuestType.listening,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.interactionType = InteractionType.reorder,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.hint,
    this.audioUrl,
    this.shuffledSentences,
    this.correctOrder,
    super.textToSpeak,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    audioUrl,
    shuffledSentences,
    correctOrder,
  ];
}
