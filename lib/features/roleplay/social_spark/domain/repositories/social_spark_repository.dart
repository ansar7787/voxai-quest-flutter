import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/social_spark/domain/entities/social_spark_quest.dart';

abstract class SocialSparkRepository {
  Future<Either<Failure, List<SocialSparkQuest>>> getSocialSparkQuests(int level);
}
