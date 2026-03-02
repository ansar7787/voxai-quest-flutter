import 'package:equatable/equatable.dart';

abstract class SituationSpeakingEvent extends Equatable {
  const SituationSpeakingEvent();

  @override
  List<Object?> get props => [];
}

class FetchSituationSpeakingQuests extends SituationSpeakingEvent {
  final int level;

  const FetchSituationSpeakingQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitSituationSpeakingAnswer extends SituationSpeakingEvent {
  final bool isCorrect;

  const SubmitSituationSpeakingAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextSituationSpeakingQuestion extends SituationSpeakingEvent {}

class RestoreSituationSpeakingLife extends SituationSpeakingEvent {}
