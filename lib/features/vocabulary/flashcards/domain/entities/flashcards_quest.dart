import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class FlashcardsQuest extends GameQuest {
  final String? word;
  final String? definition;
  final String? example;

  const FlashcardsQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.choice,
    super.options,
    super.correctAnswerIndex,
    super.correctAnswer,
    super.hint,
    this.word,
    this.definition,
    this.example,
  });

  String? get displayTarget => word ?? displayTargetFromInstruction;
  String? get displayMeaning => definition ?? example ?? correctAnswer;

  String? get displayTargetFromInstruction {
    if (instruction.contains("'") || instruction.contains('"')) {
      final regExp = RegExp("['\"](.*?)['\"]");
      final match = regExp.firstMatch(instruction);
      if (match != null) {
        return match.group(1);
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [...super.props, word, definition, example];
}
