import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/speaking/yes_no_speaking/data/datasources/yes_no_speaking_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/yes_no_speaking/domain/entities/yes_no_speaking_quest.dart';
import 'package:voxai_quest/features/speaking/yes_no_speaking/domain/repositories/yes_no_speaking_repository.dart';

class YesNoSpeakingRepositoryImpl implements YesNoSpeakingRepository {
  final YesNoSpeakingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  YesNoSpeakingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<YesNoSpeakingQuest>>> getYesNoSpeakingQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getYesNoSpeakingQuests(
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
