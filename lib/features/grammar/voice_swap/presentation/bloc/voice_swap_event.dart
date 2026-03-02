import 'package:equatable/equatable.dart';

abstract class VoiceSwapEvent extends Equatable {
  const VoiceSwapEvent();

  @override
  List<Object?> get props => [];
}

class FetchVoiceSwapQuests extends VoiceSwapEvent {
  final int level;

  const FetchVoiceSwapQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitVoiceSwapAnswer extends VoiceSwapEvent {
  final bool isCorrect;

  const SubmitVoiceSwapAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextVoiceSwapQuestion extends VoiceSwapEvent {}

class RestoreVoiceSwapLife extends VoiceSwapEvent {}

class VoiceSwapHintUsed extends VoiceSwapEvent {}
