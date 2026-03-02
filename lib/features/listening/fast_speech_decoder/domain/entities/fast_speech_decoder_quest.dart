import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class FastSpeechDecoderQuest extends GameQuest {
  final String? audioUrl;
  final String? transcript;

  const FastSpeechDecoderQuest({
    required super.id,
    super.type = QuestType.listening,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.interactionType = InteractionType.typing,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.correctAnswer,
    super.textToSpeak,
    super.hint,
    this.audioUrl,
    this.transcript,
  });

  String? get audioTranscript => transcript ?? textToSpeak;

  @override
  List<Object?> get props => [
    ...super.props,
    audioUrl,
    correctAnswer,
    transcript,
  ];
}
