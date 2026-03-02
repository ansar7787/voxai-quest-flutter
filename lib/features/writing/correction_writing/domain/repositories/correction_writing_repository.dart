import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/correction_writing/domain/entities/correction_writing_quest.dart';

abstract class CorrectionWritingRepository {
  Future<Either<Failure, List<CorrectionWritingQuest>>>
  getCorrectionWritingQuests(int level);
}
