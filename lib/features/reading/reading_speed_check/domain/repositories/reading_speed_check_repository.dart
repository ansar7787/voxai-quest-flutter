import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/reading_speed_check/domain/entities/reading_speed_check_quest.dart';

abstract class ReadingSpeedCheckRepository {
  Future<Either<Failure, List<ReadingSpeedCheckQuest>>>
  getReadingSpeedCheckQuests(int level);
}
