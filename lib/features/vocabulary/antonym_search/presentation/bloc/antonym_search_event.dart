import 'package:equatable/equatable.dart';

abstract class AntonymSearchEvent extends Equatable {
  const AntonymSearchEvent();

  @override
  List<Object?> get props => [];
}

class FetchAntonymSearchQuests extends AntonymSearchEvent {
  final int level;

  const FetchAntonymSearchQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitAntonymSearchAnswer extends AntonymSearchEvent {
  final bool isCorrect;

  const SubmitAntonymSearchAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextAntonymSearchQuestion extends AntonymSearchEvent {}

class RestoreAntonymSearchLife extends AntonymSearchEvent {}

class AntonymSearchHintUsed extends AntonymSearchEvent {}
