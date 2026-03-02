import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/scene_description_speaking/domain/entities/scene_description_speaking_quest.dart';
import 'package:voxai_quest/features/speaking/scene_description_speaking/domain/repositories/scene_description_speaking_repository.dart';

class GetSceneDescriptionSpeakingQuests {
  final SceneDescriptionSpeakingRepository repository;

  GetSceneDescriptionSpeakingQuests(this.repository);

  Future<Either<Failure, List<SceneDescriptionSpeakingQuest>>> call(
    int level,
  ) async {
    return await repository.getSceneDescriptionSpeakingQuests(level);
  }
}
