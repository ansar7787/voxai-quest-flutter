import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/idioms/domain/entities/idioms_quest.dart';

abstract class IdiomsRepository {
  Future<Either<Failure, List<IdiomsQuest>>> getIdiomsQuests(int level);
}
