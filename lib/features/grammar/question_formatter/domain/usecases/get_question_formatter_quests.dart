import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/question_formatter/domain/entities/question_formatter_quest.dart';
import 'package:voxai_quest/features/grammar/question_formatter/domain/repositories/question_formatter_repository.dart';

class GetQuestionFormatterQuests {
  final QuestionFormatterRepository repository;

  GetQuestionFormatterQuests(this.repository);

  Future<Either<Failure, List<QuestionFormatterQuest>>> call(int level) async {
    return await repository.getQuestionFormatterQuests(level);
  }
}
