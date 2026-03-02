import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class DetailSpotlightQuest extends GameQuest {
  final String? audioUrl;
  final String? question;
  final String? transcript;

  const DetailSpotlightQuest({
    required super.id,
    super.type = QuestType.listening,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.interactionType = InteractionType.choice,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.options,
    super.correctAnswerIndex,
    super.hint,
    super.textToSpeak,
    this.audioUrl,
    this.question,
    this.transcript,
  });

  String? get audioTranscript => transcript ?? textToSpeak;

  @override
  List<Object?> get props => [
    ...super.props,
    audioUrl,
    question,
    options,
    correctAnswerIndex,
    transcript,
  ];
}
