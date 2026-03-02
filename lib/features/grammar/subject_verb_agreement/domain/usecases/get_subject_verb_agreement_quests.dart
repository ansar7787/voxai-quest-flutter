import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/subject_verb_agreement/domain/entities/subject_verb_agreement_quest.dart';
import 'package:voxai_quest/features/grammar/subject_verb_agreement/domain/repositories/subject_verb_agreement_repository.dart';

class GetSubjectVerbAgreementQuests {
  final SubjectVerbAgreementRepository repository;

  GetSubjectVerbAgreementQuests(this.repository);

  Future<Either<Failure, List<SubjectVerbAgreementQuest>>> call(int level) async {
    return await repository.getSubjectVerbAgreementQuests(level);
  }
}
