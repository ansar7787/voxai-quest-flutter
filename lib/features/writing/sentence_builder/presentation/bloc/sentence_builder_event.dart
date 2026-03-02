import 'package:equatable/equatable.dart';

abstract class SentenceBuilderEvent extends Equatable {
  const SentenceBuilderEvent();

  @override
  List<Object?> get props => [];
}

class FetchSentenceBuilderQuests extends SentenceBuilderEvent {
  final int level;

  const FetchSentenceBuilderQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitSentenceBuilderAnswer extends SentenceBuilderEvent {
  final bool isCorrect;

  const SubmitSentenceBuilderAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextSentenceBuilderQuestion extends SentenceBuilderEvent {}

class RestoreSentenceBuilderLife extends SentenceBuilderEvent {}

class SentenceBuilderHintUsed extends SentenceBuilderEvent {}
