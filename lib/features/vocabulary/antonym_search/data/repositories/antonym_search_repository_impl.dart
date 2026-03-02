import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/vocabulary/antonym_search/data/datasources/antonym_search_remote_data_source.dart';
import 'package:voxai_quest/features/vocabulary/antonym_search/domain/entities/antonym_search_quest.dart';
import 'package:voxai_quest/features/vocabulary/antonym_search/domain/repositories/antonym_search_repository.dart';

class AntonymSearchRepositoryImpl implements AntonymSearchRepository {
  final AntonymSearchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AntonymSearchRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AntonymSearchQuest>>> getAntonymSearchQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getAntonymSearchQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

