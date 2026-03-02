import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class CorrectionWritingQuest extends GameQuest {
  final String? incorrectText;
  final List<String>? errors;

  const CorrectionWritingQuest({
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
    this.incorrectText,
    this.errors,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        incorrectText,
        errors,
      ];
}
