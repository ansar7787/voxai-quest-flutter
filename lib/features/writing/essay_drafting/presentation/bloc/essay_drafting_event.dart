import 'package:equatable/equatable.dart';

abstract class EssayDraftingEvent extends Equatable {
  const EssayDraftingEvent();

  @override
  List<Object?> get props => [];
}

class FetchEssayDraftingQuests extends EssayDraftingEvent {
  final int level;

  const FetchEssayDraftingQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitEssayDraftingAnswer extends EssayDraftingEvent {
  final bool isCorrect;

  const SubmitEssayDraftingAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextEssayDraftingQuestion extends EssayDraftingEvent {}

class RestoreEssayDraftingLife extends EssayDraftingEvent {}

class EssayDraftingHintUsed extends EssayDraftingEvent {}
