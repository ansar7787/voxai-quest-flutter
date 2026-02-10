import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/domain/entities/pronunciation_quest.dart';
import 'package:voxai_quest/features/speaking/domain/repositories/pronunciation_repository.dart';

class GetPronunciationQuest {
  final PronunciationRepository repository;

  GetPronunciationQuest(this.repository);

  Future<Either<Failure, PronunciationQuest>> call(int difficulty) async {
    return await repository.getPronunciationQuest(difficulty);
  }
}
