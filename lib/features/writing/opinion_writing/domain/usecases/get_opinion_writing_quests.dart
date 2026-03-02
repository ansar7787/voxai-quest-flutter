import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/opinion_writing/domain/entities/opinion_writing_quest.dart';
import 'package:voxai_quest/features/writing/opinion_writing/domain/repositories/opinion_writing_repository.dart';

class GetOpinionWritingQuests {
  final OpinionWritingRepository repository;

  GetOpinionWritingQuests(this.repository);

  Future<Either<Failure, List<OpinionWritingQuest>>> call(int level) async {
    return await repository.getOpinionWritingQuests(level);
  }
}
