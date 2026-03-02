import 'package:equatable/equatable.dart';

abstract class SpeakSynonymEvent extends Equatable {
  const SpeakSynonymEvent();

  @override
  List<Object?> get props => [];
}

class FetchSpeakSynonymQuests extends SpeakSynonymEvent {
  final int level;

  const FetchSpeakSynonymQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitSpeakSynonymAnswer extends SpeakSynonymEvent {
  final bool isCorrect;

  const SubmitSpeakSynonymAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextSpeakSynonymQuestion extends SpeakSynonymEvent {}

class RestoreSpeakSynonymLife extends SpeakSynonymEvent {}
