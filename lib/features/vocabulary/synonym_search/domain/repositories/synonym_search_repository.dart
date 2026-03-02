import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/synonym_search/domain/entities/synonym_search_quest.dart';

abstract class SynonymSearchRepository {
  Future<Either<Failure, List<SynonymSearchQuest>>> getSynonymSearchQuests(int level);
}
