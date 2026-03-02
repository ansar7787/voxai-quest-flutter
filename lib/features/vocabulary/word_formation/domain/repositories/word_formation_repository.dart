import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/word_formation/domain/entities/word_formation_quest.dart';

abstract class WordFormationRepository {
  Future<Either<Failure, List<WordFormationQuest>>> getWordFormationQuests(
    int level,
  );
}
