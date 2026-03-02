import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/antonym_search/domain/entities/antonym_search_quest.dart';

abstract class AntonymSearchRepository {
  Future<Either<Failure, List<AntonymSearchQuest>>> getAntonymSearchQuests(int level);
}
