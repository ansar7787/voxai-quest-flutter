import 'package:equatable/equatable.dart';

abstract class AudioSentenceOrderEvent extends Equatable {
  const AudioSentenceOrderEvent();

  @override
  List<Object?> get props => [];
}

class FetchAudioSentenceOrderQuests extends AudioSentenceOrderEvent {
  final int level;

  const FetchAudioSentenceOrderQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitAudioSentenceOrderAnswer extends AudioSentenceOrderEvent {
  final List<int> userOrder;
  final List<int> correctOrder;

  const SubmitAudioSentenceOrderAnswer({
    required this.userOrder,
    required this.correctOrder,
  });

  @override
  List<Object?> get props => [userOrder, correctOrder];
}

class NextAudioSentenceOrderQuestion extends AudioSentenceOrderEvent {}

class RestoreAudioSentenceOrderLife extends AudioSentenceOrderEvent {}
