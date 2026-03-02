import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/job_interview/domain/entities/job_interview_quest.dart';

abstract class JobInterviewRepository {
  Future<Either<Failure, List<JobInterviewQuest>>> getJobInterviewQuests(
    int level,
  );
}
