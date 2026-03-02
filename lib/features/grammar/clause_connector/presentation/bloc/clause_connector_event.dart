import 'package:equatable/equatable.dart';

abstract class ClauseConnectorEvent extends Equatable {
  const ClauseConnectorEvent();

  @override
  List<Object?> get props => [];
}

class FetchClauseConnectorQuests extends ClauseConnectorEvent {
  final int level;

  const FetchClauseConnectorQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitClauseConnectorAnswer extends ClauseConnectorEvent {
  final bool isCorrect;

  const SubmitClauseConnectorAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextClauseConnectorQuestion extends ClauseConnectorEvent {}

class RestoreClauseConnectorLife extends ClauseConnectorEvent {}

class ClauseConnectorHintUsed extends ClauseConnectorEvent {}
