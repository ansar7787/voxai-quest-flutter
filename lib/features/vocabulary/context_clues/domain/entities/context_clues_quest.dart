import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class ContextCluesQuest extends GameQuest {
  final String? sentence;
  final String? targetWord;

  const ContextCluesQuest({
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
    this.targetWord,
  });

  String? get displaySentence => sentence ?? instruction;

  @override
  List<Object?> get props => [...super.props, sentence, targetWord];
}
