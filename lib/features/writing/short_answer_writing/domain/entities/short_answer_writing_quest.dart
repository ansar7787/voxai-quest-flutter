import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class ShortAnswerWritingQuest extends GameQuest {
  final String? questionPrompt;
  final List<String>? acceptableKeywords;

  const ShortAnswerWritingQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.text,
    super.options,
    super.correctAnswerIndex,
    super.correctAnswer,
    super.hint,
    this.questionPrompt,
    this.acceptableKeywords,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        questionPrompt,
        acceptableKeywords,
      ];
}
