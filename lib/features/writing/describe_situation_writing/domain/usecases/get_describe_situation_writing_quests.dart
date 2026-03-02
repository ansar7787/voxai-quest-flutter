import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/describe_situation_writing/domain/entities/describe_situation_writing_quest.dart';
import 'package:voxai_quest/features/writing/describe_situation_writing/domain/repositories/describe_situation_writing_repository.dart';

class GetDescribeSituationWritingQuests {
  final DescribeSituationWritingRepository repository;

  GetDescribeSituationWritingQuests(this.repository);

  Future<Either<Failure, List<DescribeSituationWritingQuest>>> call(
    int level,
  ) async {
    return await repository.getDescribeSituationWritingQuests(level);
  }
}
