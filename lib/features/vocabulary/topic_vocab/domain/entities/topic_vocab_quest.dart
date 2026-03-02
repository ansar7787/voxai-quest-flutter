import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class TopicVocabQuest extends GameQuest {
  final String? topic;
  final String? word;
  final String? definition;
  final String? example;
  final String? category;

  const TopicVocabQuest({
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
    this.topic,
    this.word,
    this.definition,
    this.example,
    this.category,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    topic,
    word,
    definition,
    example,
    category,
  ];
}
