import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/topic_vocab/domain/entities/topic_vocab_quest.dart';

abstract class TopicVocabRepository {
  Future<Either<Failure, List<TopicVocabQuest>>> getTopicVocabQuests(int level);
}
