import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/reading/read_and_answer/data/datasources/read_and_answer_remote_data_source.dart';
import 'package:voxai_quest/features/reading/read_and_answer/domain/entities/read_and_answer_quest.dart';
import 'package:voxai_quest/features/reading/read_and_answer/domain/repositories/read_and_answer_repository.dart';

class ReadAndAnswerRepositoryImpl implements ReadAndAnswerRepository {
  final ReadAndAnswerRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ReadAndAnswerRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ReadAndAnswerQuest>>> getReadAndAnswerQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getReadAndAnswerQuests(
          level,
        );
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}
