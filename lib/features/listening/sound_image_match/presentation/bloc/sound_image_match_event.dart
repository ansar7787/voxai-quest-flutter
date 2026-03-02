import 'package:equatable/equatable.dart';

abstract class SoundImageMatchEvent extends Equatable {
  const SoundImageMatchEvent();

  @override
  List<Object?> get props => [];
}

class FetchSoundImageMatchQuests extends SoundImageMatchEvent {
  final int level;

  const FetchSoundImageMatchQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitSoundImageMatchAnswer extends SoundImageMatchEvent {
  final int userIndex;
  final int correctIndex;

  const SubmitSoundImageMatchAnswer({
    required this.userIndex,
    required this.correctIndex,
  });

  @override
  List<Object?> get props => [userIndex, correctIndex];
}

class NextSoundImageMatchQuestion extends SoundImageMatchEvent {}

class RestoreSoundImageMatchLife extends SoundImageMatchEvent {}
