import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/summarize_story_writing/domain/entities/summarize_story_writing_quest.dart';
import 'package:voxai_quest/features/writing/summarize_story_writing/domain/repositories/summarize_story_writing_repository.dart';

class GetSummarizeStoryWritingQuests {
  final SummarizeStoryWritingRepository repository;

  GetSummarizeStoryWritingQuests(this.repository);

  Future<Either<Failure, List<SummarizeStoryWritingQuest>>> call(
    int level,
  ) async {
    return await repository.getSummarizeStoryWritingQuests(level);
  }
}
