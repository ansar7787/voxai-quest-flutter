import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/true_false_reading/domain/entities/true_false_reading_quest.dart';

abstract class TrueFalseReadingRepository {
  Future<Either<Failure, List<TrueFalseReadingQuest>>>
  getTrueFalseReadingQuests(int level);
}
