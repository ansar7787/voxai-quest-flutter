import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/idioms/domain/entities/idioms_quest.dart';
import 'package:voxai_quest/features/vocabulary/idioms/domain/repositories/idioms_repository.dart';

class GetIdiomsQuests {
  final IdiomsRepository repository;

  GetIdiomsQuests(this.repository);

  Future<Either<Failure, List<IdiomsQuest>>> call(int level) async {
    return await repository.getIdiomsQuests(level);
  }
}
