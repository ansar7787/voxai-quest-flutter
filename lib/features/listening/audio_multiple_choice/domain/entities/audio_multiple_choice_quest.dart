import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class AudioMultipleChoiceQuest extends GameQuest {
  final String? audioUrl;
  final String? transcript;

  const AudioMultipleChoiceQuest({
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
    this.audioUrl,
    super.textToSpeak,
    this.transcript,
  });

  String? get audioTranscript => transcript ?? textToSpeak;
  String get question => instruction;

  @override
  List<Object?> get props => [
    ...super.props,
    audioUrl,
    textToSpeak,
    options,
    correctAnswerIndex,
    transcript,
  ];
}
