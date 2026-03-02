import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/grammar/clause_connector/data/datasources/clause_connector_remote_data_source.dart';
import 'package:voxai_quest/features/grammar/clause_connector/domain/entities/clause_connector_quest.dart';
import 'package:voxai_quest/features/grammar/clause_connector/domain/repositories/clause_connector_repository.dart';

class ClauseConnectorRepositoryImpl implements ClauseConnectorRepository {
  final ClauseConnectorRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ClauseConnectorRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ClauseConnectorQuest>>> getClauseConnectorQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getClauseConnectorQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

