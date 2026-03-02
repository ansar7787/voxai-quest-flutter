import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class SentenceBuilderQuest extends GameQuest {
  final String? prompt;
  final List<String>? scrambledWords;

  const SentenceBuilderQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType =
        InteractionType.choice, // Special handling for building sentences
    super.options,
    super.correctAnswerIndex,
    super.correctAnswer,
    super.hint,
    this.prompt,
    this.scrambledWords,
  });

  @override
  List<Object?> get props => [...super.props, prompt, scrambledWords];
}
