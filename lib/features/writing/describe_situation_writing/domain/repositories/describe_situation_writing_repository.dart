import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/describe_situation_writing/domain/entities/describe_situation_writing_quest.dart';

abstract class DescribeSituationWritingRepository {
  Future<Either<Failure, List<DescribeSituationWritingQuest>>>
  getDescribeSituationWritingQuests(int level);
}
