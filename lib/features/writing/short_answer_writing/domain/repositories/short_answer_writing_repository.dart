import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/short_answer_writing/domain/entities/short_answer_writing_quest.dart';

abstract class ShortAnswerWritingRepository {
  Future<Either<Failure, List<ShortAnswerWritingQuest>>> getShortAnswerWritingQuests(int level);
}
