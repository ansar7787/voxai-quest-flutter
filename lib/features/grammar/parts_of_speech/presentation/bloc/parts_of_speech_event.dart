import 'package:equatable/equatable.dart';

abstract class PartsOfSpeechEvent extends Equatable {
  const PartsOfSpeechEvent();

  @override
  List<Object?> get props => [];
}

class FetchPartsOfSpeechQuests extends PartsOfSpeechEvent {
  final int level;

  const FetchPartsOfSpeechQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitPartsOfSpeechAnswer extends PartsOfSpeechEvent {
  final bool isCorrect;

  const SubmitPartsOfSpeechAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextPartsOfSpeechQuestion extends PartsOfSpeechEvent {}

class RestorePartsOfSpeechLife extends PartsOfSpeechEvent {}

class PartsOfSpeechHintUsed extends PartsOfSpeechEvent {}
