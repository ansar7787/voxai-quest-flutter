import 'package:equatable/equatable.dart';

abstract class SentenceOrderReadingEvent extends Equatable {
  const SentenceOrderReadingEvent();

  @override
  List<Object?> get props => [];
}

class FetchSentenceOrderReadingQuests extends SentenceOrderReadingEvent {
  final int level;

  const FetchSentenceOrderReadingQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitSentenceOrderReadingAnswer extends SentenceOrderReadingEvent {
  final bool isCorrect;

  const SubmitSentenceOrderReadingAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextSentenceOrderReadingQuestion extends SentenceOrderReadingEvent {}

class RestoreSentenceOrderReadingLife extends SentenceOrderReadingEvent {}

class SentenceOrderReadingHintUsed extends SentenceOrderReadingEvent {}
