import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/listening/ambient_id/data/datasources/ambient_id_remote_data_source.dart';
import 'package:voxai_quest/features/listening/ambient_id/domain/entities/ambient_id_quest.dart';
import 'package:voxai_quest/features/listening/ambient_id/domain/repositories/ambient_id_repository.dart';

class AmbientIdRepositoryImpl implements AmbientIdRepository {
  final AmbientIdRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AmbientIdRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AmbientIdQuest>>> getQuests(int level) async {
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
