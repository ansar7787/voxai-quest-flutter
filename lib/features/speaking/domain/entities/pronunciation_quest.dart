import 'package:voxai_quest/features/game/domain/entities/game_quest.dart';

class PronunciationQuest extends GameQuest {
  final String word;
  final String phonetic;
  final String audioUrl;

  PronunciationQuest({
    required super.id,
    required super.instruction,
    required super.difficulty,
    required this.word,
    required this.phonetic,
    this.audioUrl = "",
  }) : super(type: QuestType.pronunciation);
}
