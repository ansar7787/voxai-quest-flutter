import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/paragraph_summary/domain/entities/paragraph_summary_quest.dart';

abstract class ParagraphSummaryRepository {
  Future<Either<Failure, List<ParagraphSummaryQuest>>> getParagraphSummaryQuests(int level);
}
