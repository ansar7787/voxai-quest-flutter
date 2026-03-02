import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/antonym_search/domain/entities/antonym_search_quest.dart';
import 'package:voxai_quest/features/vocabulary/antonym_search/domain/repositories/antonym_search_repository.dart';

class GetAntonymSearchQuests {
  final AntonymSearchRepository repository;

  GetAntonymSearchQuests(this.repository);

  Future<Either<Failure, List<AntonymSearchQuest>>> call(int level) async {
    return await repository.getAntonymSearchQuests(level);
  }
}
