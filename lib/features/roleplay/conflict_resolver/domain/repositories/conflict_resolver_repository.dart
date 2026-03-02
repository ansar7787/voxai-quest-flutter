import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/conflict_resolver/domain/entities/conflict_resolver_quest.dart';

abstract class ConflictResolverRepository {
  Future<Either<Failure, List<ConflictResolverQuest>>> getConflictResolverQuests(int level);
}
