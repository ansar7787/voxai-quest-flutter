import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/domain/entities/speaking_quest.dart';

abstract class SpeakingRepository {
  Future<Either<Failure, SpeakingQuest>> getSpeakingQuest(int difficulty);
}
