import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/read_and_answer/domain/entities/read_and_answer_quest.dart';
import 'package:voxai_quest/features/reading/read_and_answer/domain/repositories/read_and_answer_repository.dart';

class GetReadAndAnswerQuests {
  final ReadAndAnswerRepository repository;

  GetReadAndAnswerQuests(this.repository);

  Future<Either<Failure, List<ReadAndAnswerQuest>>> call(int level) async {
    return await repository.getReadAndAnswerQuests(level);
  }
}
