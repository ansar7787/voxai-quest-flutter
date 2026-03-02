import 'package:equatable/equatable.dart';

abstract class AudioTrueFalseEvent extends Equatable {
  const AudioTrueFalseEvent();

  @override
  List<Object?> get props => [];
}

class FetchAudioTrueFalseQuests extends AudioTrueFalseEvent {
  final int level;

  const FetchAudioTrueFalseQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitAudioTrueFalseAnswer extends AudioTrueFalseEvent {
  final bool userAnswer;
  final bool correctAnswer;

  const SubmitAudioTrueFalseAnswer({
    required this.userAnswer,
    required this.correctAnswer,
  });

  @override
  List<Object?> get props => [userAnswer, correctAnswer];
}

class NextAudioTrueFalseQuestion extends AudioTrueFalseEvent {}

class RestoreAudioTrueFalseLife extends AudioTrueFalseEvent {}
