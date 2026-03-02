import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/speak_opposite/domain/entities/speak_opposite_quest.dart';

abstract class SpeakOppositeRepository {
  Future<Either<Failure, List<SpeakOppositeQuest>>> getSpeakOppositeQuests(int level);
}
