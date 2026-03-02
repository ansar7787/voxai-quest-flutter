import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class AudioTrueFalseQuest extends GameQuest {
  final String? audioUrl;
  final String? statement;
  final bool? isTrue;
  final String? transcript;

  const AudioTrueFalseQuest({
    required super.id,
    super.type = QuestType.listening,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.interactionType = InteractionType.trueFalse,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.hint,
    super.textToSpeak,
    this.audioUrl,
    this.statement,
    this.isTrue,
    this.transcript,
  });

  String? get audioTranscript => transcript ?? textToSpeak;

  @override
  List<Object?> get props => [
    ...super.props,
    audioUrl,
    statement,
    isTrue,
    transcript,
  ];
}
