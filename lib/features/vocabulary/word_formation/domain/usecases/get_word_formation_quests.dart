import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/word_formation/domain/entities/word_formation_quest.dart';
import 'package:voxai_quest/features/vocabulary/word_formation/domain/repositories/word_formation_repository.dart';

class GetWordFormationQuests {
  final WordFormationRepository repository;

  GetWordFormationQuests(this.repository);

  Future<Either<Failure, List<WordFormationQuest>>> call(int level) async {
    return await repository.getWordFormationQuests(level);
  }
}
