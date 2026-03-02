import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/vocabulary/idioms/data/datasources/idioms_remote_data_source.dart';
import 'package:voxai_quest/features/vocabulary/idioms/domain/entities/idioms_quest.dart';
import 'package:voxai_quest/features/vocabulary/idioms/domain/repositories/idioms_repository.dart';

class IdiomsRepositoryImpl implements IdiomsRepository {
  final IdiomsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  IdiomsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<IdiomsQuest>>> getIdiomsQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getIdiomsQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

