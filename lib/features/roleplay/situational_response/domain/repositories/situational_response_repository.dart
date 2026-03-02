import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/situational_response/domain/entities/situational_response_quest.dart';

abstract class SituationalResponseRepository {
  Future<Either<Failure, List<SituationalResponseQuest>>> getSituationalResponseQuests(int level);
}
