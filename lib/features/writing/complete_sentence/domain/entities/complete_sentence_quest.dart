import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class CompleteSentenceQuest extends GameQuest {
  final String? partialSentence;
  final String? completion;

  const CompleteSentenceQuest({
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
    this.partialSentence,
    this.completion,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        partialSentence,
        completion,
      ];
}
