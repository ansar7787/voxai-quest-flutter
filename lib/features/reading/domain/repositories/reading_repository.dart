import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/domain/entities/reading_quest.dart';

abstract class ReadingRepository {
  Future<Either<Failure, ReadingQuest>> getReadingQuest(int difficulty);
}
