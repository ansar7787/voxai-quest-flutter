import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/social_spark/domain/entities/social_spark_quest.dart';
import 'package:voxai_quest/features/roleplay/social_spark/domain/repositories/social_spark_repository.dart';

class GetSocialSparkQuests {
  final SocialSparkRepository repository;

  GetSocialSparkQuests(this.repository);

  Future<Either<Failure, List<SocialSparkQuest>>> call(int level) async {
    return await repository.getSocialSparkQuests(level);
  }
}
