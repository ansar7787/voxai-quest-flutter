import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/essay_drafting/domain/entities/essay_drafting_quest.dart';
import 'package:voxai_quest/features/writing/essay_drafting/domain/repositories/essay_drafting_repository.dart';

class GetEssayDraftingQuests {
  final EssayDraftingRepository repository;

  GetEssayDraftingQuests(this.repository);

  Future<Either<Failure, List<EssayDraftingQuest>>> call(int level) async {
    return await repository.getEssayDraftingQuests(level);
  }
}
