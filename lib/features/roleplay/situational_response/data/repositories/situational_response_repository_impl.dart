import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/roleplay/situational_response/domain/entities/situational_response_quest.dart';
import 'package:voxai_quest/features/roleplay/situational_response/domain/repositories/situational_response_repository.dart';
import 'package:voxai_quest/features/roleplay/situational_response/data/datasources/situational_response_remote_data_source.dart';

class SituationalResponseRepositoryImpl
    implements SituationalResponseRepository {
  final SituationalResponseRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SituationalResponseRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SituationalResponseQuest>>>
  getSituationalResponseQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource
            .getSituationalResponseQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return const Left(ServerFailure('Failed to fetch from server'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
