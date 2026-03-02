import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/grammar/tense_mastery/data/datasources/tense_mastery_remote_data_source.dart';
import 'package:voxai_quest/features/grammar/tense_mastery/domain/entities/tense_mastery_quest.dart';
import 'package:voxai_quest/features/grammar/tense_mastery/domain/repositories/tense_mastery_repository.dart';

class TenseMasteryRepositoryImpl implements TenseMasteryRepository {
  final TenseMasteryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TenseMasteryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TenseMasteryQuest>>> getTenseMasteryQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getTenseMasteryQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

