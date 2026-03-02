import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/question_formatter/domain/entities/question_formatter_quest.dart';

abstract class QuestionFormatterRepository {
  Future<Either<Failure, List<QuestionFormatterQuest>>> getQuestionFormatterQuests(int level);
}
