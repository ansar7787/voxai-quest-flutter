import 'package:equatable/equatable.dart';

abstract class FastSpeechDecoderEvent extends Equatable {
  const FastSpeechDecoderEvent();

  @override
  List<Object?> get props => [];
}

class FetchFastSpeechDecoderQuests extends FastSpeechDecoderEvent {
  final int level;

  const FetchFastSpeechDecoderQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitFastSpeechDecoderAnswer extends FastSpeechDecoderEvent {
  final String answer;
  final String correctAnswer;

  const SubmitFastSpeechDecoderAnswer({
    required this.answer,
    required this.correctAnswer,
  });

  @override
  List<Object?> get props => [answer, correctAnswer];
}

class NextFastSpeechDecoderQuestion extends FastSpeechDecoderEvent {}

class RestoreFastSpeechDecoderLife extends FastSpeechDecoderEvent {}
