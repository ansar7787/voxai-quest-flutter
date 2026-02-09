import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/reading/domain/entities/reading_quest.dart';
import 'package:voxai_quest/features/reading/domain/repositories/reading_repository.dart';

class GetReadingQuest implements UseCase<ReadingQuest, int> {
  final ReadingRepository repository;

  GetReadingQuest(this.repository);

  @override
  Future<Either<Failure, ReadingQuest>> call(int difficulty) async {
    return await repository.getReadingQuest(difficulty);
  }
}
