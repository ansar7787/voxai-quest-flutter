import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class SentenceOrderReadingQuest extends GameQuest {
  final List<String>? shuffledSentences;
  final List<int>? correctOrder;

  const SentenceOrderReadingQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.sequence,
    super.options,
    super.correctAnswerIndex,
    super.correctAnswer,
    super.hint,
    this.shuffledSentences,
    this.correctOrder,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        shuffledSentences,
        correctOrder,
      ];
}
