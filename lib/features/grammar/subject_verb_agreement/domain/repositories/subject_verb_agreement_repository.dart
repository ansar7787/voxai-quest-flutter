import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/subject_verb_agreement/domain/entities/subject_verb_agreement_quest.dart';

abstract class SubjectVerbAgreementRepository {
  Future<Either<Failure, List<SubjectVerbAgreementQuest>>> getSubjectVerbAgreementQuests(int level);
}
