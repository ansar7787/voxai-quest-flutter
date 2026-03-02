import 'package:equatable/equatable.dart';

abstract class SynonymSearchEvent extends Equatable {
  const SynonymSearchEvent();

  @override
  List<Object?> get props => [];
}

class FetchSynonymSearchQuests extends SynonymSearchEvent {
  final int level;

  const FetchSynonymSearchQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitSynonymSearchAnswer extends SynonymSearchEvent {
  final bool isCorrect;

  const SubmitSynonymSearchAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextSynonymSearchQuestion extends SynonymSearchEvent {}

class RestoreSynonymSearchLife extends SynonymSearchEvent {}

class SynonymSearchHintUsed extends SynonymSearchEvent {}
