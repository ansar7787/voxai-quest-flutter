import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/scene_description_speaking/domain/entities/scene_description_speaking_quest.dart';

abstract class SceneDescriptionSpeakingRepository {
  Future<Either<Failure, List<SceneDescriptionSpeakingQuest>>> getSceneDescriptionSpeakingQuests(int level);
}
