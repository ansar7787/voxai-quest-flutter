import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/sentence_builder/domain/entities/sentence_builder_quest.dart';
import 'package:voxai_quest/features/writing/sentence_builder/domain/repositories/sentence_builder_repository.dart';

class GetSentenceBuilderQuests {
  final SentenceBuilderRepository repository;

  GetSentenceBuilderQuests(this.repository);

  Future<Either<Failure, List<SentenceBuilderQuest>>> call(int level) async {
    return await repository.getSentenceBuilderQuests(level);
  }
}
