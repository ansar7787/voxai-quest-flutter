import 'package:equatable/equatable.dart';

abstract class SubjectVerbAgreementEvent extends Equatable {
  const SubjectVerbAgreementEvent();

  @override
  List<Object?> get props => [];
}

class FetchSubjectVerbAgreementQuests extends SubjectVerbAgreementEvent {
  final int level;

  const FetchSubjectVerbAgreementQuests(this.level);

  @override
  List<Object?> get props => [level];
}

class SubmitSubjectVerbAgreementAnswer extends SubjectVerbAgreementEvent {
  final bool isCorrect;

  const SubmitSubjectVerbAgreementAnswer(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}

class NextSubjectVerbAgreementQuestion extends SubjectVerbAgreementEvent {}

class RestoreSubjectVerbAgreementLife extends SubjectVerbAgreementEvent {}

class SubjectVerbAgreementHintUsed extends SubjectVerbAgreementEvent {}
