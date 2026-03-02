import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/correction_writing/domain/entities/correction_writing_quest.dart';
import 'package:voxai_quest/features/writing/correction_writing/domain/repositories/correction_writing_repository.dart';

class GetCorrectionWritingQuests {
  final CorrectionWritingRepository repository;

  GetCorrectionWritingQuests(this.repository);

  Future<Either<Failure, List<CorrectionWritingQuest>>> call(int level) async {
    return await repository.getCorrectionWritingQuests(level);
  }
}
