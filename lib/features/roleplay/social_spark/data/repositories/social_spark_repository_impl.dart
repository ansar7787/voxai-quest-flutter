import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/roleplay/social_spark/domain/entities/social_spark_quest.dart';
import 'package:voxai_quest/features/roleplay/social_spark/domain/repositories/social_spark_repository.dart';
import 'package:voxai_quest/features/roleplay/social_spark/data/datasources/social_spark_remote_data_source.dart';

class SocialSparkRepositoryImpl implements SocialSparkRepository {
  final SocialSparkRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SocialSparkRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SocialSparkQuest>>> getSocialSparkQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getSocialSparkQuests(level);
        return Right(remoteQuests);
      } on ServerException {
        return Left(ServerFailure('Server error occurred'));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}
