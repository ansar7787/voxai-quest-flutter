import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/phrasal_verbs/domain/entities/phrasal_verbs_quest.dart';

abstract class PhrasalVerbsRepository {
  Future<Either<Failure, List<PhrasalVerbsQuest>>> getPhrasalVerbsQuests(int level);
}
