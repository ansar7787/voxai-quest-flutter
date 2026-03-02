import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/read_and_answer/domain/entities/read_and_answer_quest.dart';

abstract class ReadAndAnswerRepository {
  Future<Either<Failure, List<ReadAndAnswerQuest>>> getReadAndAnswerQuests(int level);
}
