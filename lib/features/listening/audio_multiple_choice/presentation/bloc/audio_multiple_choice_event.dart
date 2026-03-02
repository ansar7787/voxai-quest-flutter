import 'package:equatable/equatable.dart';

abstract class AudioMultipleChoiceEvent extends Equatable {
  const AudioMultipleChoiceEvent();

  @override
  List<Object?> get props => [];
}

class FetchAudioMultipleChoiceQuests extends AudioMultipleChoiceEvent {
  final int level;

  const FetchAudioMultipleChoiceQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitAudioMultipleChoiceAnswer extends AudioMultipleChoiceEvent {
  final int selectedIndex;
  final int correctIndex;

  const SubmitAudioMultipleChoiceAnswer({
    required this.selectedIndex,
    required this.correctIndex,
  });

  @override
  List<Object?> get props => [selectedIndex, correctIndex];
}

class NextAudioMultipleChoiceQuestion extends AudioMultipleChoiceEvent {}

class RestoreAudioMultipleChoiceLife extends AudioMultipleChoiceEvent {}
