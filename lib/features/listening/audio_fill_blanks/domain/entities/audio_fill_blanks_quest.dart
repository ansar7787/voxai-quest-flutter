import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class AudioFillBlanksQuest extends GameQuest {
  final String? audioUrl;
  final String? transcript;
  final String missingWord;

  const AudioFillBlanksQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.interactionType = InteractionType.writing,
    super.xpReward = 10,
    super.coinReward = 10,
    super.livesAllowed = 3,
    super.options,
    super.correctAnswerIndex,
    super.correctAnswer,
    super.hint,
    super.textToSpeak,
    this.audioUrl,
    this.transcript,
    required this.missingWord,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    audioUrl,
    transcript,
    missingWord,
  ];

  String? get audioTranscript => transcript ?? textToSpeak;
}
