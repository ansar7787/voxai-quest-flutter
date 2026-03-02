import 'package:equatable/equatable.dart';

abstract class AmbientIdEvent extends Equatable {
  const AmbientIdEvent();

  @override
  List<Object?> get props => [];
}

class FetchAmbientIdQuests extends AmbientIdEvent {
  final int level;

  const FetchAmbientIdQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitAmbientIdAnswer extends AmbientIdEvent {
  final int userIndex;
  final int? correctIndex;

  const SubmitAmbientIdAnswer({
    required this.userIndex,
    required this.correctIndex,
  });

  @override
  List<Object?> get props => [userIndex, correctIndex];
}

class NextAmbientIdQuestion extends AmbientIdEvent {}

class RestoreAmbientIdLife extends AmbientIdEvent {}
