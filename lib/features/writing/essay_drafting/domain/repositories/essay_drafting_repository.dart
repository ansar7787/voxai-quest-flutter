import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/essay_drafting/domain/entities/essay_drafting_quest.dart';

abstract class EssayDraftingRepository {
  Future<Either<Failure, List<EssayDraftingQuest>>> getEssayDraftingQuests(int level);
}
