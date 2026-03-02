import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class ListeningInferenceQuest extends GameQuest {
  final String? audioUrl;
  final String? transcript;

  const ListeningInferenceQuest({
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
    this.transcript,
  });

  String? get audioTranscript => transcript ?? textToSpeak;

  @override
  List<Object?> get props => [
    ...super.props,
    audioUrl,
    options,
    correctAnswerIndex,
    transcript,
  ];
}
