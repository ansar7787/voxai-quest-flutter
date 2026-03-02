import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/writing/opinion_writing/data/datasources/opinion_writing_remote_data_source.dart';
import 'package:voxai_quest/features/writing/opinion_writing/domain/entities/opinion_writing_quest.dart';
import 'package:voxai_quest/features/writing/opinion_writing/domain/repositories/opinion_writing_repository.dart';

class OpinionWritingRepositoryImpl implements OpinionWritingRepository {
  final OpinionWritingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OpinionWritingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<OpinionWritingQuest>>> getOpinionWritingQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getOpinionWritingQuests(
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
