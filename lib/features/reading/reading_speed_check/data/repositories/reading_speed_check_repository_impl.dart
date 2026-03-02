import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/reading/reading_speed_check/data/datasources/reading_speed_check_remote_data_source.dart';
import 'package:voxai_quest/features/reading/reading_speed_check/domain/entities/reading_speed_check_quest.dart';
import 'package:voxai_quest/features/reading/reading_speed_check/domain/repositories/reading_speed_check_repository.dart';

class ReadingSpeedCheckRepositoryImpl implements ReadingSpeedCheckRepository {
  final ReadingSpeedCheckRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ReadingSpeedCheckRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ReadingSpeedCheckQuest>>> getReadingSpeedCheckQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getReadingSpeedCheckQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

