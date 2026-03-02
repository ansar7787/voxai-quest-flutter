import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class PrefixSuffixQuest extends GameQuest {
  final String? targetWord;
  final String? sentence;

  const PrefixSuffixQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.choice,
    super.options,
    super.correctAnswerIndex,
    super.correctAnswer,
    super.hint,
    this.targetWord,
    this.sentence,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        targetWord,
        sentence,
      ];
}
