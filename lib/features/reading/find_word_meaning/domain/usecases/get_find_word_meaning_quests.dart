import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/find_word_meaning/domain/entities/find_word_meaning_quest.dart';
import 'package:voxai_quest/features/reading/find_word_meaning/domain/repositories/find_word_meaning_repository.dart';

class GetFindWordMeaningQuests {
  final FindWordMeaningRepository repository;

  GetFindWordMeaningQuests(this.repository);

  Future<Either<Failure, List<FindWordMeaningQuest>>> call(int level) async {
    return await repository.getFindWordMeaningQuests(level);
  }
}
