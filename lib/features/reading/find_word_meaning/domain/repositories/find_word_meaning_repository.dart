import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/find_word_meaning/domain/entities/find_word_meaning_quest.dart';

abstract class FindWordMeaningRepository {
  Future<Either<Failure, List<FindWordMeaningQuest>>> getFindWordMeaningQuests(
    int level,
  );
}
