import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/sentence_builder/domain/entities/sentence_builder_quest.dart';

abstract class SentenceBuilderRepository {
  Future<Either<Failure, List<SentenceBuilderQuest>>> getSentenceBuilderQuests(int level);
}
