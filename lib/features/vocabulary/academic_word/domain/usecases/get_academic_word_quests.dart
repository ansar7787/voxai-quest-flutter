import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/academic_word/domain/entities/academic_word_quest.dart';
import 'package:voxai_quest/features/vocabulary/academic_word/domain/repositories/academic_word_repository.dart';

class GetAcademicWordQuests {
  final AcademicWordRepository repository;

  GetAcademicWordQuests(this.repository);

  Future<Either<Failure, List<AcademicWordQuest>>> call(int level) async {
    return await repository.getAcademicWordQuests(level);
  }
}
