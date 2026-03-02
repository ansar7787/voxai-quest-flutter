import 'package:equatable/equatable.dart';

abstract class ReadingSpeedCheckEvent extends Equatable {
  const ReadingSpeedCheckEvent();

  @override
  List<Object?> get props => [];
}

class FetchReadingSpeedCheckQuests extends ReadingSpeedCheckEvent {
  final int level;

  const FetchReadingSpeedCheckQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitReadingSpeedCheckAnswer extends ReadingSpeedCheckEvent {
  final bool isCorrect;

  const SubmitReadingSpeedCheckAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextReadingSpeedCheckQuestion extends ReadingSpeedCheckEvent {}

class RestoreReadingSpeedCheckLife extends ReadingSpeedCheckEvent {}

class ReadingSpeedCheckHintUsed extends ReadingSpeedCheckEvent {}
