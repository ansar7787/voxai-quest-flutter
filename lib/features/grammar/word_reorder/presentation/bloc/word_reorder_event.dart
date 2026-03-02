import 'package:equatable/equatable.dart';

abstract class WordReorderEvent extends Equatable {
  const WordReorderEvent();

  @override
  List<Object?> get props => [];
}

class FetchWordReorderQuests extends WordReorderEvent {
  final int level;

  const FetchWordReorderQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitWordReorderAnswer extends WordReorderEvent {
  final bool isCorrect;

  const SubmitWordReorderAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextWordReorderQuestion extends WordReorderEvent {}

class RestoreWordReorderLife extends WordReorderEvent {}

class WordReorderHintUsed extends WordReorderEvent {}
