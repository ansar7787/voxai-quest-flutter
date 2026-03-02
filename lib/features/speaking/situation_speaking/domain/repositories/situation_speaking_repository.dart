import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/situation_speaking/domain/entities/situation_speaking_quest.dart';

abstract class SituationSpeakingRepository {
  Future<Either<Failure, List<SituationSpeakingQuest>>> getSituationSpeakingQuests(int level);
}
