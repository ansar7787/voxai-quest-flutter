import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class JobInterviewQuest extends GameQuest {
  final String? question;
  final List<String>? sampleAnswers;
  final List<String>? keyPoints;
  final String? role;
  final String? company;

  const JobInterviewQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType,
    super.options,
    super.correctAnswerIndex,
    this.question,
    this.sampleAnswers,
    this.keyPoints,
    this.role,
    this.company,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    question,
    sampleAnswers,
    keyPoints,
    role,
    company,
  ];
}
