import 'package:equatable/equatable.dart';

abstract class GrammarQuestEvent extends Equatable {
  const GrammarQuestEvent();

  @override
  List<Object?> get props => [];
}

class FetchGrammarQuestQuests extends GrammarQuestEvent {
  final int level;

  const FetchGrammarQuestQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitGrammarQuestAnswer extends GrammarQuestEvent {
  final bool isCorrect;

  const SubmitGrammarQuestAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextGrammarQuestQuestion extends GrammarQuestEvent {}

class RestoreGrammarQuestLife extends GrammarQuestEvent {}

class GrammarQuestHintUsed extends GrammarQuestEvent {}
