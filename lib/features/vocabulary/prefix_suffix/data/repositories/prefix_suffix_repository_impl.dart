import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/vocabulary/prefix_suffix/data/datasources/prefix_suffix_remote_data_source.dart';
import 'package:voxai_quest/features/vocabulary/prefix_suffix/domain/entities/prefix_suffix_quest.dart';
import 'package:voxai_quest/features/vocabulary/prefix_suffix/domain/repositories/prefix_suffix_repository.dart';

class PrefixSuffixRepositoryImpl implements PrefixSuffixRepository {
  final PrefixSuffixRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PrefixSuffixRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PrefixSuffixQuest>>> getPrefixSuffixQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getPrefixSuffixQuests(
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
