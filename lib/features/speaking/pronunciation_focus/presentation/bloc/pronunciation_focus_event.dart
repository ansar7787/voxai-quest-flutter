import 'package:equatable/equatable.dart';

abstract class PronunciationFocusEvent extends Equatable {
  const PronunciationFocusEvent();

  @override
  List<Object?> get props => [];
}

class FetchPronunciationFocusQuests extends PronunciationFocusEvent {
  final int level;

  const FetchPronunciationFocusQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitPronunciationFocusAnswer extends PronunciationFocusEvent {
  final bool isCorrect;
  final double accuracyScore;

  const SubmitPronunciationFocusAnswer({
    required this.isCorrect,
    required this.accuracyScore,
  });

  @override
  List<Object?> get props => [isCorrect, accuracyScore];
}

class NextPronunciationFocusQuestion extends PronunciationFocusEvent {}

class RestorePronunciationFocusLife extends PronunciationFocusEvent {}
