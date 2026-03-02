import 'package:equatable/equatable.dart';

abstract class SceneDescriptionSpeakingEvent extends Equatable {
  const SceneDescriptionSpeakingEvent();

  @override
  List<Object?> get props => [];
}

class FetchSceneDescriptionSpeakingQuests extends SceneDescriptionSpeakingEvent {
  final int level;

  const FetchSceneDescriptionSpeakingQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitSceneDescriptionSpeakingAnswer extends SceneDescriptionSpeakingEvent {
  final bool isCorrect;

  const SubmitSceneDescriptionSpeakingAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextSceneDescriptionSpeakingQuestion extends SceneDescriptionSpeakingEvent {}

class RestoreSceneDescriptionSpeakingLife extends SceneDescriptionSpeakingEvent {}
