import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class VoiceSwapQuest extends GameQuest {
  final String? originalSentence;
  final String? targetVoice;

  const VoiceSwapQuest({
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
    this.originalSentence,
    this.targetVoice,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        originalSentence,
        targetVoice,
      ];
}
