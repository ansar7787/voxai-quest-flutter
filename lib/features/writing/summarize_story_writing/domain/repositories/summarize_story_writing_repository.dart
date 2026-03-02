import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/summarize_story_writing/domain/entities/summarize_story_writing_quest.dart';

abstract class SummarizeStoryWritingRepository {
  Future<Either<Failure, List<SummarizeStoryWritingQuest>>> getSummarizeStoryWritingQuests(int level);
}
