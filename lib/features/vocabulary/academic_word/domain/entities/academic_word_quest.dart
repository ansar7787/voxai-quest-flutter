import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class AcademicWordQuest extends GameQuest {
  final String? word;
  final String? definition;
  final String? example;
  final String? synonym;
  final String? antonym;

  const AcademicWordQuest({
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
    this.synonym,
    this.antonym,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    word,
    definition,
    example,
    synonym,
    antonym,
  ];
}
