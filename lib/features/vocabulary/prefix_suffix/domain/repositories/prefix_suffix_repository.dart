import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/prefix_suffix/domain/entities/prefix_suffix_quest.dart';

abstract class PrefixSuffixRepository {
  Future<Either<Failure, List<PrefixSuffixQuest>>> getPrefixSuffixQuests(
    int level,
  );
}
