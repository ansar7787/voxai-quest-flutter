import 'package:equatable/equatable.dart';

abstract class JobInterviewEvent extends Equatable {
  const JobInterviewEvent();

  @override
  List<Object?> get props => [];
}

class FetchJobInterviewQuests extends JobInterviewEvent {
  final int level;
  const FetchJobInterviewQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitJobInterviewAnswer extends JobInterviewEvent {
  final bool isCorrect;
  const SubmitJobInterviewAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextJobInterviewQuestion extends JobInterviewEvent {}

class RestoreJobInterviewLife extends JobInterviewEvent {}

class JobInterviewHintUsed extends JobInterviewEvent {}


class RestartLevel extends JobInterviewEvent {}

