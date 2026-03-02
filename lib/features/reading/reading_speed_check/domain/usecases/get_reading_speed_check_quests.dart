import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/reading_speed_check/domain/entities/reading_speed_check_quest.dart';
import 'package:voxai_quest/features/reading/reading_speed_check/domain/repositories/reading_speed_check_repository.dart';

class GetReadingSpeedCheckQuests {
  final ReadingSpeedCheckRepository repository;

  GetReadingSpeedCheckQuests(this.repository);

  Future<Either<Failure, List<ReadingSpeedCheckQuest>>> call(int level) async {
    return await repository.getReadingSpeedCheckQuests(level);
  }
}
