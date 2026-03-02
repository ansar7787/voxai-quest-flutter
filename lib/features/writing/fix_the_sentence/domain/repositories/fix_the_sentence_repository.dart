import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/fix_the_sentence/domain/entities/fix_the_sentence_quest.dart';

abstract class FixTheSentenceRepository {
  Future<Either<Failure, List<FixTheSentenceQuest>>> getFixTheSentenceQuests(int level);
}
