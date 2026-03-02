import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class DailyJournalQuest extends GameQuest {
  final String? journalPrompt;
  final List<String>? guidedQuestions;

  const DailyJournalQuest({
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
    this.journalPrompt,
    this.guidedQuestions,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        journalPrompt,
        guidedQuestions,
      ];
}
