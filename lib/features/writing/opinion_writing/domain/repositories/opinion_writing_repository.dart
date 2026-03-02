import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/opinion_writing/domain/entities/opinion_writing_quest.dart';

abstract class OpinionWritingRepository {
  Future<Either<Failure, List<OpinionWritingQuest>>> getOpinionWritingQuests(int level);
}
