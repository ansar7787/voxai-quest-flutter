import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class GrammarQuestQuest extends GameQuest {
  final String? questionText;
  final String? explanation;

  const GrammarQuestQuest({
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
    this.questionText,
    this.explanation,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        questionText,
        explanation,
      ];
}
