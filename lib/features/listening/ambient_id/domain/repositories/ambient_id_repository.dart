import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/ambient_id/domain/entities/ambient_id_quest.dart';

abstract class AmbientIdRepository {
  Future<Either<Failure, List<AmbientIdQuest>>> getQuests(int level);
}
