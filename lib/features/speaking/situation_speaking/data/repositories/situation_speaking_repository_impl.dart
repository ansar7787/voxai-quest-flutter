import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/speaking/situation_speaking/data/datasources/situation_speaking_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/situation_speaking/domain/entities/situation_speaking_quest.dart';
import 'package:voxai_quest/features/speaking/situation_speaking/domain/repositories/situation_speaking_repository.dart';

class SituationSpeakingRepositoryImpl implements SituationSpeakingRepository {
  final SituationSpeakingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SituationSpeakingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SituationSpeakingQuest>>>
  getSituationSpeakingQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getSituationSpeakingQuests(
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
