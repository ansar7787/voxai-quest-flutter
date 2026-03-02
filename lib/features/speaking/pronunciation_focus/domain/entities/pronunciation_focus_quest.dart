import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class PronunciationFocusQuest extends GameQuest {
  final String? word;
  final String? phoneticHint;
  final String? audioUrl;
  final String? translation;

  const PronunciationFocusQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.speech,
    this.word,
    this.phoneticHint,
    this.audioUrl,
    this.translation,
  });

  String? get phoneticScript => phoneticHint;

  @override
  List<Object?> get props => [
    ...super.props,
    word,
    phoneticHint,
    audioUrl,
    translation,
  ];
}
