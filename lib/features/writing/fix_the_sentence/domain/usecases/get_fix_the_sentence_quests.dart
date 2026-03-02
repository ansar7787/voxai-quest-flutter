import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/fix_the_sentence/domain/entities/fix_the_sentence_quest.dart';
import 'package:voxai_quest/features/writing/fix_the_sentence/domain/repositories/fix_the_sentence_repository.dart';

class GetFixTheSentenceQuests {
  final FixTheSentenceRepository repository;

  GetFixTheSentenceQuests(this.repository);

  Future<Either<Failure, List<FixTheSentenceQuest>>> call(int level) async {
    return await repository.getFixTheSentenceQuests(level);
  }
}
