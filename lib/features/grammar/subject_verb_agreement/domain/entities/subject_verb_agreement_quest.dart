import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class SubjectVerbAgreementQuest extends GameQuest {
  final String? sentenceWithBlank;
  final String? subject;

  const SubjectVerbAgreementQuest({
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
    this.subject,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        sentenceWithBlank,
        subject,
      ];
}
