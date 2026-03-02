import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/job_interview/domain/entities/job_interview_quest.dart';
import 'package:voxai_quest/features/roleplay/job_interview/domain/repositories/job_interview_repository.dart';

class GetJobInterviewQuests {
  final JobInterviewRepository repository;

  GetJobInterviewQuests(this.repository);

  Future<Either<Failure, List<JobInterviewQuest>>> call(int level) async {
    return await repository.getJobInterviewQuests(level);
  }
}
