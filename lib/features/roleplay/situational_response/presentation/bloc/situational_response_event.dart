import 'package:equatable/equatable.dart';

abstract class SituationalResponseEvent extends Equatable {
  const SituationalResponseEvent();

  @override
  List<Object?> get props => [];
}

class FetchSituationalResponseQuests extends SituationalResponseEvent {
  final int level;
  const FetchSituationalResponseQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitSituationalResponseAnswer extends SituationalResponseEvent {
  final bool isCorrect;
  const SubmitSituationalResponseAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextSituationalResponseQuestion extends SituationalResponseEvent {}

class RestoreSituationalResponseLife extends SituationalResponseEvent {}

class SituationalResponseHintUsed extends SituationalResponseEvent {}

class RestartLevel extends SituationalResponseEvent {}
