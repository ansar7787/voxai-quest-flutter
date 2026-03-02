import 'package:equatable/equatable.dart';

abstract class WritingEmailEvent extends Equatable {
  const WritingEmailEvent();

  @override
  List<Object?> get props => [];
}

class FetchWritingEmailQuests extends WritingEmailEvent {
  final int level;

  const FetchWritingEmailQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitWritingEmailAnswer extends WritingEmailEvent {
  final bool isCorrect;

  const SubmitWritingEmailAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextWritingEmailQuestion extends WritingEmailEvent {}

class RestoreWritingEmailLife extends WritingEmailEvent {}

class WritingEmailHintUsed extends WritingEmailEvent {}
