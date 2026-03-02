import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class FixTheSentenceQuest extends GameQuest {
  final String? incorrectSentence;
  final String? correction;

  const FixTheSentenceQuest({
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
    this.incorrectSentence,
    this.correction,
  });

  @override
  List<Object?> get props => [...super.props, incorrectSentence, correction];
}
