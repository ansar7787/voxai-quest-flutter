import 'package:equatable/equatable.dart';

abstract class CorrectionWritingEvent extends Equatable {
  const CorrectionWritingEvent();

  @override
  List<Object?> get props => [];
}

class FetchCorrectionWritingQuests extends CorrectionWritingEvent {
  final int level;

  const FetchCorrectionWritingQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitCorrectionWritingAnswer extends CorrectionWritingEvent {
  final bool isCorrect;

  const SubmitCorrectionWritingAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextCorrectionWritingQuestion extends CorrectionWritingEvent {}

class RestoreCorrectionWritingLife extends CorrectionWritingEvent {}

class CorrectionWritingHintUsed extends CorrectionWritingEvent {}
