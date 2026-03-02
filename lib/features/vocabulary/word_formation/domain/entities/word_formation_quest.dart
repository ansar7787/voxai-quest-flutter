import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class WordFormationQuest extends GameQuest {
  final String? root;
  final String? sentence;

  const WordFormationQuest({
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
    this.root,
    this.sentence,
  });

  @override
  List<Object?> get props => [...super.props, root, sentence];
}
