import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/phrasal_verbs/domain/entities/phrasal_verbs_quest.dart';
import 'package:voxai_quest/features/vocabulary/phrasal_verbs/domain/repositories/phrasal_verbs_repository.dart';

class GetPhrasalVerbsQuests {
  final PhrasalVerbsRepository repository;

  GetPhrasalVerbsQuests(this.repository);

  Future<Either<Failure, List<PhrasalVerbsQuest>>> call(int level) async {
    return await repository.getPhrasalVerbsQuests(level);
  }
}
