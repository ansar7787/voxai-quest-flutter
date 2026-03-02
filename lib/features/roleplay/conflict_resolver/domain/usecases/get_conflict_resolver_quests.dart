import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/conflict_resolver/domain/entities/conflict_resolver_quest.dart';
import 'package:voxai_quest/features/roleplay/conflict_resolver/domain/repositories/conflict_resolver_repository.dart';

class GetConflictResolverQuests {
  final ConflictResolverRepository repository;

  GetConflictResolverQuests(this.repository);

  Future<Either<Failure, List<ConflictResolverQuest>>> call(int level) async {
    return await repository.getConflictResolverQuests(level);
  }
}
