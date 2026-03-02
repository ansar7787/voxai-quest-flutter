import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/speaking/scene_description_speaking/data/datasources/scene_description_speaking_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/scene_description_speaking/domain/entities/scene_description_speaking_quest.dart';
import 'package:voxai_quest/features/speaking/scene_description_speaking/domain/repositories/scene_description_speaking_repository.dart';

class SceneDescriptionSpeakingRepositoryImpl
    implements SceneDescriptionSpeakingRepository {
  final SceneDescriptionSpeakingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SceneDescriptionSpeakingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SceneDescriptionSpeakingQuest>>>
  getSceneDescriptionSpeakingQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource
            .getSceneDescriptionSpeakingQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}
