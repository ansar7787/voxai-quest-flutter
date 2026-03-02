import 'package:equatable/equatable.dart';

abstract class TravelDeskEvent extends Equatable {
  const TravelDeskEvent();

  @override
  List<Object?> get props => [];
}

class FetchTravelDeskQuests extends TravelDeskEvent {
  final int level;
  const FetchTravelDeskQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitTravelDeskAnswer extends TravelDeskEvent {
  final bool isCorrect;
  const SubmitTravelDeskAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextTravelDeskQuestion extends TravelDeskEvent {}

class RestoreTravelDeskLife extends TravelDeskEvent {}

class TravelDeskHintUsed extends TravelDeskEvent {}


class RestartLevel extends TravelDeskEvent {}

