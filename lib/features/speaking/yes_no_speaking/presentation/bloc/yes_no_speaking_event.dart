import 'package:equatable/equatable.dart';

abstract class YesNoSpeakingEvent extends Equatable {
  const YesNoSpeakingEvent();

  @override
  List<Object?> get props => [];
}

class FetchYesNoSpeakingQuests extends YesNoSpeakingEvent {
  final int level;

  const FetchYesNoSpeakingQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitYesNoSpeakingAnswer extends YesNoSpeakingEvent {
  final bool isCorrect;

  const SubmitYesNoSpeakingAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextYesNoSpeakingQuestion extends YesNoSpeakingEvent {}

class RestoreYesNoSpeakingLife extends YesNoSpeakingEvent {}
