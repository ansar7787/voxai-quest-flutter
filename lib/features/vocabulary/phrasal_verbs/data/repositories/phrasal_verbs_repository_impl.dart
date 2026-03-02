import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/vocabulary/phrasal_verbs/data/datasources/phrasal_verbs_remote_data_source.dart';
import 'package:voxai_quest/features/vocabulary/phrasal_verbs/domain/entities/phrasal_verbs_quest.dart';
import 'package:voxai_quest/features/vocabulary/phrasal_verbs/domain/repositories/phrasal_verbs_repository.dart';

class PhrasalVerbsRepositoryImpl implements PhrasalVerbsRepository {
  final PhrasalVerbsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PhrasalVerbsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PhrasalVerbsQuest>>> getPhrasalVerbsQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getPhrasalVerbsQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

