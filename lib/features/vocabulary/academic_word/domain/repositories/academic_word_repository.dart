import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/academic_word/domain/entities/academic_word_quest.dart';

abstract class AcademicWordRepository {
  Future<Either<Failure, List<AcademicWordQuest>>> getAcademicWordQuests(int level);
}
