import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/roleplay/conflict_resolver/domain/entities/conflict_resolver_quest.dart';
import 'package:voxai_quest/features/roleplay/conflict_resolver/domain/repositories/conflict_resolver_repository.dart';
import 'package:voxai_quest/features/roleplay/conflict_resolver/data/datasources/conflict_resolver_remote_data_source.dart';

class ConflictResolverRepositoryImpl implements ConflictResolverRepository {
  final ConflictResolverRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ConflictResolverRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ConflictResolverQuest>>>
  getConflictResolverQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getConflictResolverQuests(
          level,
        );
        return Right(remoteQuests);
      } on ServerException {
        return Left(ServerFailure('Server error occurred'));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}
