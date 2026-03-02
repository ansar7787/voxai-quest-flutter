import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class ArticleInsertionQuest extends GameQuest {
  final String? sentenceWithBlank;
  final String? articleToInsert;

  const ArticleInsertionQuest({
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
    this.sentenceWithBlank,
    this.articleToInsert,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        sentenceWithBlank,
        articleToInsert,
      ];
}
