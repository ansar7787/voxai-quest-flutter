import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class PhrasalVerbsQuest extends GameQuest {
  final String? sentence;
  final String? phrasalVerb;

  const PhrasalVerbsQuest({
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
    this.sentence,
    this.phrasalVerb,
  });

  String? get displaySentence => sentence ?? instruction;

  @override
  List<Object?> get props => [
        ...super.props,
        sentence,
        phrasalVerb,
      ];
}
