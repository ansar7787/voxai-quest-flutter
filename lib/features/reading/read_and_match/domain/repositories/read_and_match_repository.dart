import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/read_and_match/domain/entities/read_and_match_quest.dart';

abstract class ReadAndMatchRepository {
  Future<Either<Failure, List<ReadAndMatchQuest>>> getReadAndMatchQuests(int level);
}
