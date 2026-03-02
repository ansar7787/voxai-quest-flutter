import 'package:equatable/equatable.dart';

abstract class EmotionRecognitionEvent extends Equatable {
  const EmotionRecognitionEvent();

  @override
  List<Object?> get props => [];
}

class FetchEmotionRecognitionQuests extends EmotionRecognitionEvent {
  final int level;

  const FetchEmotionRecognitionQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitEmotionRecognitionAnswer extends EmotionRecognitionEvent {
  final int userIndex;
  final int correctIndex;

  const SubmitEmotionRecognitionAnswer({
    required this.userIndex,
    required this.correctIndex,
  });

  @override
  List<Object?> get props => [userIndex, correctIndex];
}

class NextEmotionRecognitionQuestion extends EmotionRecognitionEvent {}

class RestoreEmotionRecognitionLife extends EmotionRecognitionEvent {}
