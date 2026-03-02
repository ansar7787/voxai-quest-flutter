import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/listening/detail_spotlight/data/datasources/detail_spotlight_remote_data_source.dart';
import 'package:voxai_quest/features/listening/detail_spotlight/domain/entities/detail_spotlight_quest.dart';
import 'package:voxai_quest/features/listening/detail_spotlight/domain/repositories/detail_spotlight_repository.dart';

class DetailSpotlightRepositoryImpl implements DetailSpotlightRepository {
  final DetailSpotlightRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DetailSpotlightRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<DetailSpotlightQuest>>> getQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }
}
