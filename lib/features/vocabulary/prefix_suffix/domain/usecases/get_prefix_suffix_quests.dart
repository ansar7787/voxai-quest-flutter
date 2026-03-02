import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/prefix_suffix/domain/entities/prefix_suffix_quest.dart';
import 'package:voxai_quest/features/vocabulary/prefix_suffix/domain/repositories/prefix_suffix_repository.dart';

class GetPrefixSuffixQuests {
  final PrefixSuffixRepository repository;

  GetPrefixSuffixQuests(this.repository);

  Future<Either<Failure, List<PrefixSuffixQuest>>> call(int level) async {
    return await repository.getPrefixSuffixQuests(level);
  }
}
