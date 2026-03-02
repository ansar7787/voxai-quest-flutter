import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/topic_vocab/domain/entities/topic_vocab_quest.dart';
import 'package:voxai_quest/features/vocabulary/topic_vocab/domain/repositories/topic_vocab_repository.dart';

class GetTopicVocabQuests {
  final TopicVocabRepository repository;

  GetTopicVocabQuests(this.repository);

  Future<Either<Failure, List<TopicVocabQuest>>> call(int level) async {
    return await repository.getTopicVocabQuests(level);
  }
}
