import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/reading/read_and_match/data/datasources/read_and_match_remote_data_source.dart';
import 'package:voxai_quest/features/reading/read_and_match/domain/entities/read_and_match_quest.dart';
import 'package:voxai_quest/features/reading/read_and_match/domain/repositories/read_and_match_repository.dart';

class ReadAndMatchRepositoryImpl implements ReadAndMatchRepository {
  final ReadAndMatchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ReadAndMatchRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ReadAndMatchQuest>>> getReadAndMatchQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getReadAndMatchQuests(
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
