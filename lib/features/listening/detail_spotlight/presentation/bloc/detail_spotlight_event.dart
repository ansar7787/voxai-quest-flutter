import 'package:equatable/equatable.dart';

abstract class DetailSpotlightEvent extends Equatable {
  const DetailSpotlightEvent();

  @override
  List<Object?> get props => [];
}

class FetchDetailSpotlightQuests extends DetailSpotlightEvent {
  final int level;

  const FetchDetailSpotlightQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitDetailSpotlightAnswer extends DetailSpotlightEvent {
  final int userIndex;
  final int correctIndex;

  const SubmitDetailSpotlightAnswer({
    required this.userIndex,
    required this.correctIndex,
  });

  @override
  List<Object?> get props => [userIndex, correctIndex];
}

class NextDetailSpotlightQuestion extends DetailSpotlightEvent {}

class RestoreDetailSpotlightLife extends DetailSpotlightEvent {}
