import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/writing/domain/entities/writing_quest.dart';
import 'package:voxai_quest/features/writing/domain/repositories/writing_repository.dart';

class GetWritingQuest implements UseCase<WritingQuest, int> {
  final WritingRepository repository;

  GetWritingQuest(this.repository);

  @override
  Future<Either<Failure, WritingQuest>> call(int difficulty) async {
    return await repository.getWritingQuest(difficulty);
  }
}
