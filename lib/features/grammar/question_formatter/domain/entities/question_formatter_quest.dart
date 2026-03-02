import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class QuestionFormatterQuest extends GameQuest {
  final String? statement;
  final String? questionType;

  const QuestionFormatterQuest({
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
    this.statement,
    this.questionType,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        statement,
        questionType,
      ];
}
