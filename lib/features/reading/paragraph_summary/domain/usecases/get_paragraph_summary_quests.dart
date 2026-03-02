import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/paragraph_summary/domain/entities/paragraph_summary_quest.dart';
import 'package:voxai_quest/features/reading/paragraph_summary/domain/repositories/paragraph_summary_repository.dart';

class GetParagraphSummaryQuests {
  final ParagraphSummaryRepository repository;

  GetParagraphSummaryQuests(this.repository);

  Future<Either<Failure, List<ParagraphSummaryQuest>>> call(int level) async {
    return await repository.getParagraphSummaryQuests(level);
  }
}
