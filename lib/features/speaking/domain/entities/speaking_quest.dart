import 'package:voxai_quest/features/game/domain/entities/game_quest.dart';

class SpeakingQuest extends GameQuest {
  final String textToSpeak;

  SpeakingQuest({
    required super.id,
    required super.instruction,
    required super.difficulty,
    required this.textToSpeak,
  }) : super(type: QuestType.speaking);
}
