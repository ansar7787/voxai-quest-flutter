import 'package:equatable/equatable.dart';

abstract class ReadAndMatchEvent extends Equatable {
  const ReadAndMatchEvent();

  @override
  List<Object?> get props => [];
}

class FetchReadAndMatchQuests extends ReadAndMatchEvent {
  final int level;

  const FetchReadAndMatchQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitReadAndMatchAnswer extends ReadAndMatchEvent {
  final bool isCorrect;

  const SubmitReadAndMatchAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextReadAndMatchQuestion extends ReadAndMatchEvent {}

class RestoreReadAndMatchLife extends ReadAndMatchEvent {}

class ReadAndMatchHintUsed extends ReadAndMatchEvent {}
