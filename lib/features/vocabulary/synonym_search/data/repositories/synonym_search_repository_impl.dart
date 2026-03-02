import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/vocabulary/synonym_search/data/datasources/synonym_search_remote_data_source.dart';
import 'package:voxai_quest/features/vocabulary/synonym_search/domain/entities/synonym_search_quest.dart';
import 'package:voxai_quest/features/vocabulary/synonym_search/domain/repositories/synonym_search_repository.dart';

class SynonymSearchRepositoryImpl implements SynonymSearchRepository {
  final SynonymSearchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SynonymSearchRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SynonymSearchQuest>>> getSynonymSearchQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getSynonymSearchQuests(
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
