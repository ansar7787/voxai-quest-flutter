import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/context_clues/domain/entities/context_clues_quest.dart';
import 'package:voxai_quest/features/vocabulary/context_clues/domain/repositories/context_clues_repository.dart';

class GetContextCluesQuests {
  final ContextCluesRepository repository;

  GetContextCluesQuests(this.repository);

  Future<Either<Failure, List<ContextCluesQuest>>> call(int level) async {
    return await repository.getContextCluesQuests(level);
  }
}
