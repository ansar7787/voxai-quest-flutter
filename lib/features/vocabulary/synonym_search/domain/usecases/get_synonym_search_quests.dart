import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/synonym_search/domain/entities/synonym_search_quest.dart';
import 'package:voxai_quest/features/vocabulary/synonym_search/domain/repositories/synonym_search_repository.dart';

class GetSynonymSearchQuests {
  final SynonymSearchRepository repository;

  GetSynonymSearchQuests(this.repository);

  Future<Either<Failure, List<SynonymSearchQuest>>> call(int level) async {
    return await repository.getSynonymSearchQuests(level);
  }
}
