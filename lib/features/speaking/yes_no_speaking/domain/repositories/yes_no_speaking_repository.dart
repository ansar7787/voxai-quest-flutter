import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/yes_no_speaking/domain/entities/yes_no_speaking_quest.dart';

abstract class YesNoSpeakingRepository {
  Future<Either<Failure, List<YesNoSpeakingQuest>>> getYesNoSpeakingQuests(int level);
}
