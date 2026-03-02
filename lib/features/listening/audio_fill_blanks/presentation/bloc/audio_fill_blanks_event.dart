import 'package:equatable/equatable.dart';

abstract class AudioFillBlanksEvent extends Equatable {
  const AudioFillBlanksEvent();

  @override
  List<Object?> get props => [];
}

class FetchAudioFillBlanksQuests extends AudioFillBlanksEvent {
  final int level;

  const FetchAudioFillBlanksQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitAudioFillBlanksAnswer extends AudioFillBlanksEvent {
  final bool isCorrect;

  const SubmitAudioFillBlanksAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextAudioFillBlanksQuestion extends AudioFillBlanksEvent {}

class RestoreAudioFillBlanksLife extends AudioFillBlanksEvent {}
