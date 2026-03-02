import 'package:equatable/equatable.dart';

abstract class GuessTitleEvent extends Equatable {
  const GuessTitleEvent();

  @override
  List<Object?> get props => [];
}

class FetchGuessTitleQuests extends GuessTitleEvent {
  final int level;

  const FetchGuessTitleQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitGuessTitleAnswer extends GuessTitleEvent {
  final bool isCorrect;

  const SubmitGuessTitleAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextGuessTitleQuestion extends GuessTitleEvent {}

class RestoreGuessTitleLife extends GuessTitleEvent {}

class GuessTitleHintUsed extends GuessTitleEvent {}
