import 'package:equatable/equatable.dart';

abstract class GourmetOrderEvent extends Equatable {
  const GourmetOrderEvent();

  @override
  List<Object?> get props => [];
}

class FetchGourmetOrderQuests extends GourmetOrderEvent {
  final int level;
  const FetchGourmetOrderQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitGourmetOrderAnswer extends GourmetOrderEvent {
  final bool isCorrect;
  const SubmitGourmetOrderAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextGourmetOrderQuestion extends GourmetOrderEvent {}

class RestoreGourmetOrderLife extends GourmetOrderEvent {}

class GourmetOrderHintUsed extends GourmetOrderEvent {}

class RestartLevel extends GourmetOrderEvent {}
