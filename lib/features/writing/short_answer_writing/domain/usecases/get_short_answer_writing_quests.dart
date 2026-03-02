import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/short_answer_writing/domain/entities/short_answer_writing_quest.dart';
import 'package:voxai_quest/features/writing/short_answer_writing/domain/repositories/short_answer_writing_repository.dart';

class GetShortAnswerWritingQuests {
  final ShortAnswerWritingRepository repository;

  GetShortAnswerWritingQuests(this.repository);

  Future<Either<Failure, List<ShortAnswerWritingQuest>>> call(int level) async {
    return await repository.getShortAnswerWritingQuests(level);
  }
}
