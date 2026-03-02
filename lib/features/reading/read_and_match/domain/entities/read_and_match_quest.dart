import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class ReadAndMatchQuest extends GameQuest {
  final Map<String, String>? pairs; // Map of items to match (e.g., word to definition)

  const ReadAndMatchQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.choice, // Match is a special case
    super.options,
    super.correctAnswerIndex,
    super.correctAnswer,
    super.hint,
    this.pairs,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        pairs,
      ];
}
