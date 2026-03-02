import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class WordReorderQuest extends GameQuest {
  final List<String>? words;
  final String? orderedSentence;

  const WordReorderQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.reorder,
    super.options,
    super.correctAnswerIndex,
    super.correctAnswer,
    super.hint,
    this.words,
    this.orderedSentence,
  });

  @override
  List<Object?> get props => [...super.props, words, orderedSentence];
}
