import 'package:equatable/equatable.dart';

abstract class ConflictResolverEvent extends Equatable {
  const ConflictResolverEvent();

  @override
  List<Object?> get props => [];
}

class FetchConflictResolverQuests extends ConflictResolverEvent {
  final int level;
  const FetchConflictResolverQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitConflictResolverAnswer extends ConflictResolverEvent {
  final bool isCorrect;
  const SubmitConflictResolverAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextConflictResolverQuestion extends ConflictResolverEvent {}

class RestoreConflictResolverLife extends ConflictResolverEvent {}

class ConflictResolverHintUsed extends ConflictResolverEvent {}


class RestartLevel extends ConflictResolverEvent {}

