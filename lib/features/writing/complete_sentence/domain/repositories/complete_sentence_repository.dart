import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/complete_sentence/domain/entities/complete_sentence_quest.dart';

abstract class CompleteSentenceRepository {
  Future<Either<Failure, List<CompleteSentenceQuest>>>
  getCompleteSentenceQuests(int level);
}
