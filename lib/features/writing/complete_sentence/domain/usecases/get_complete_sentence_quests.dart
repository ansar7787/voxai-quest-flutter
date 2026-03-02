import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/complete_sentence/domain/entities/complete_sentence_quest.dart';
import 'package:voxai_quest/features/writing/complete_sentence/domain/repositories/complete_sentence_repository.dart';

class GetCompleteSentenceQuests {
  final CompleteSentenceRepository repository;

  GetCompleteSentenceQuests(this.repository);

  Future<Either<Failure, List<CompleteSentenceQuest>>> call(int level) async {
    return await repository.getCompleteSentenceQuests(level);
  }
}
