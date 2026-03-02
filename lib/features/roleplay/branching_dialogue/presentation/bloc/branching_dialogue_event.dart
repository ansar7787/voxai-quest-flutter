import 'package:equatable/equatable.dart';

abstract class BranchingDialogueEvent extends Equatable {
  const BranchingDialogueEvent();

  @override
  List<Object?> get props => [];
}

class FetchBranchingDialogueQuests extends BranchingDialogueEvent {
  final int level;
  const FetchBranchingDialogueQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitBranchingDialogueAnswer extends BranchingDialogueEvent {
  final bool isCorrect;
  const SubmitBranchingDialogueAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextBranchingDialogueQuestion extends BranchingDialogueEvent {}

class RestoreBranchingDialogueLife extends BranchingDialogueEvent {}

class BranchingDialogueHintUsed extends BranchingDialogueEvent {}


class RestartLevel extends BranchingDialogueEvent {}

