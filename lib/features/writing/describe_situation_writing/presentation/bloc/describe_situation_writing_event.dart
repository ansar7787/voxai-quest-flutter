import 'package:equatable/equatable.dart';

abstract class DescribeSituationWritingEvent extends Equatable {
  const DescribeSituationWritingEvent();

  @override
  List<Object?> get props => [];
}

class FetchDescribeSituationWritingQuests extends DescribeSituationWritingEvent {
  final int level;

  const FetchDescribeSituationWritingQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitDescribeSituationWritingAnswer extends DescribeSituationWritingEvent {
  final bool isCorrect;

  const SubmitDescribeSituationWritingAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextDescribeSituationWritingQuestion extends DescribeSituationWritingEvent {}

class RestoreDescribeSituationWritingLife extends DescribeSituationWritingEvent {}

class DescribeSituationWritingHintUsed extends DescribeSituationWritingEvent {}
