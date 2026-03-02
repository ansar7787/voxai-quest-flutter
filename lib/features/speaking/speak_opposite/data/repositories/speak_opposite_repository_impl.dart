import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/speaking/speak_opposite/data/datasources/speak_opposite_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/speak_opposite/domain/entities/speak_opposite_quest.dart';
import 'package:voxai_quest/features/speaking/speak_opposite/domain/repositories/speak_opposite_repository.dart';

class SpeakOppositeRepositoryImpl implements SpeakOppositeRepository {
  final SpeakOppositeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SpeakOppositeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SpeakOppositeQuest>>> getSpeakOppositeQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getSpeakOppositeQuests(
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
