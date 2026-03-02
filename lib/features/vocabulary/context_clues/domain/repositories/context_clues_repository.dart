import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/context_clues/domain/entities/context_clues_quest.dart';

abstract class ContextCluesRepository {
  Future<Either<Failure, List<ContextCluesQuest>>> getContextCluesQuests(
    int level,
  );
}
