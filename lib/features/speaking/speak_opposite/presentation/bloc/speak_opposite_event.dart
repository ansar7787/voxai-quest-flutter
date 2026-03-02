import 'package:equatable/equatable.dart';

abstract class SpeakOppositeEvent extends Equatable {
  const SpeakOppositeEvent();

  @override
  List<Object?> get props => [];
}

class FetchSpeakOppositeQuests extends SpeakOppositeEvent {
  final int level;

  const FetchSpeakOppositeQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitSpeakOppositeAnswer extends SpeakOppositeEvent {
  final bool isCorrect;

  const SubmitSpeakOppositeAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextSpeakOppositeQuestion extends SpeakOppositeEvent {}

class RestoreSpeakOppositeLife extends SpeakOppositeEvent {}
