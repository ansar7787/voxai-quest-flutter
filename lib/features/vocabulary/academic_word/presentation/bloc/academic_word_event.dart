import 'package:equatable/equatable.dart';

abstract class AcademicWordEvent extends Equatable {
  const AcademicWordEvent();

  @override
  List<Object?> get props => [];
}

class FetchAcademicWordQuests extends AcademicWordEvent {
  final int level;

  const FetchAcademicWordQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitAcademicWordAnswer extends AcademicWordEvent {
  final bool isCorrect;

  const SubmitAcademicWordAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextAcademicWordQuestion extends AcademicWordEvent {}

class RestoreAcademicWordLife extends AcademicWordEvent {}

class AcademicWordHintUsed extends AcademicWordEvent {}
