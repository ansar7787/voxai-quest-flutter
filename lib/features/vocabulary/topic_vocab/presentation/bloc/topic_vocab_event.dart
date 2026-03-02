import 'package:equatable/equatable.dart';

abstract class TopicVocabEvent extends Equatable {
  const TopicVocabEvent();

  @override
  List<Object?> get props => [];
}

class FetchTopicVocabQuests extends TopicVocabEvent {
  final int level;

  const FetchTopicVocabQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitTopicVocabAnswer extends TopicVocabEvent {
  final bool isCorrect;

  const SubmitTopicVocabAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextTopicVocabQuestion extends TopicVocabEvent {}

class RestoreTopicVocabLife extends TopicVocabEvent {}

class TopicVocabHintUsed extends TopicVocabEvent {}
