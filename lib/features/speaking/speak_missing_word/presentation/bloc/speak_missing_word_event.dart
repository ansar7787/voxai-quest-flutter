import 'package:equatable/equatable.dart';

abstract class SpeakMissingWordEvent extends Equatable {
  const SpeakMissingWordEvent();

  @override
  List<Object?> get props => [];
}

class FetchSpeakMissingWordQuests extends SpeakMissingWordEvent {
  final int level;

  const FetchSpeakMissingWordQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitSpeakMissingWordAnswer extends SpeakMissingWordEvent {
  final bool isCorrect;

  const SubmitSpeakMissingWordAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextSpeakMissingWordQuestion extends SpeakMissingWordEvent {}

class RestoreSpeakMissingWordLife extends SpeakMissingWordEvent {}
