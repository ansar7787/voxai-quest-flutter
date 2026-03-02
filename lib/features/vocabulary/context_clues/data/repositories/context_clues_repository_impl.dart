import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/vocabulary/context_clues/data/datasources/context_clues_remote_data_source.dart';
import 'package:voxai_quest/features/vocabulary/context_clues/domain/entities/context_clues_quest.dart';
import 'package:voxai_quest/features/vocabulary/context_clues/domain/repositories/context_clues_repository.dart';

class ContextCluesRepositoryImpl implements ContextCluesRepository {
  final ContextCluesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ContextCluesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ContextCluesQuest>>> getContextCluesQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getContextCluesQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

