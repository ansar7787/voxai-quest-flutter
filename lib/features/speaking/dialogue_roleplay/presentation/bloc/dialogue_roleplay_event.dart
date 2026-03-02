import 'package:equatable/equatable.dart';

abstract class DialogueRoleplayEvent extends Equatable {
  const DialogueRoleplayEvent();

  @override
  List<Object?> get props => [];
}

class FetchDialogueRoleplayQuests extends DialogueRoleplayEvent {
  final int level;

  const FetchDialogueRoleplayQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitDialogueRoleplayAnswer extends DialogueRoleplayEvent {
  final bool isCorrect;

  const SubmitDialogueRoleplayAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextDialogueRoleplayQuestion extends DialogueRoleplayEvent {}

class NextDialogueTurn extends DialogueRoleplayEvent {}

class RestoreDialogueRoleplayLife extends DialogueRoleplayEvent {}
