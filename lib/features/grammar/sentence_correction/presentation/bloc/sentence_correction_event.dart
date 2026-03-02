import 'package:equatable/equatable.dart';

abstract class SentenceCorrectionEvent extends Equatable {
  const SentenceCorrectionEvent();

  @override
  List<Object?> get props => [];
}

class FetchSentenceCorrectionQuests extends SentenceCorrectionEvent {
  final int level;

  const FetchSentenceCorrectionQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitSentenceCorrectionAnswer extends SentenceCorrectionEvent {
  final bool isCorrect;

  const SubmitSentenceCorrectionAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextSentenceCorrectionQuestion extends SentenceCorrectionEvent {}

class RestoreSentenceCorrectionLife extends SentenceCorrectionEvent {}

class SentenceCorrectionHintUsed extends SentenceCorrectionEvent {}
