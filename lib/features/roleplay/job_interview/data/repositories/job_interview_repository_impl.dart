import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/roleplay/job_interview/domain/entities/job_interview_quest.dart';
import 'package:voxai_quest/features/roleplay/job_interview/domain/repositories/job_interview_repository.dart';
import 'package:voxai_quest/features/roleplay/job_interview/data/datasources/job_interview_remote_data_source.dart';

class JobInterviewRepositoryImpl implements JobInterviewRepository {
  final JobInterviewRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  JobInterviewRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<JobInterviewQuest>>> getJobInterviewQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getJobInterviewQuests(
          level,
        );
        return Right(remoteQuests);
      } on ServerException {
        return Left(ServerFailure('Server error occurred'));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}
