import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class SummarizeStoryWritingQuest extends GameQuest {
  final String? storyText;
  final String? storyTitle;
  final List<String>? mainPoints;

  const SummarizeStoryWritingQuest({
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
    this.storyText,
    this.storyTitle,
    this.mainPoints,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        storyText,
        storyTitle,
        mainPoints,
      ];
}
