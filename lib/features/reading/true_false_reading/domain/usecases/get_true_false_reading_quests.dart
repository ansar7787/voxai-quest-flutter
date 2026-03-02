import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/true_false_reading/domain/entities/true_false_reading_quest.dart';
import 'package:voxai_quest/features/reading/true_false_reading/domain/repositories/true_false_reading_repository.dart';

class GetTrueFalseReadingQuests {
  final TrueFalseReadingRepository repository;

  GetTrueFalseReadingQuests(this.repository);

  Future<Either<Failure, List<TrueFalseReadingQuest>>> call(int level) async {
    return await repository.getTrueFalseReadingQuests(level);
  }
}
