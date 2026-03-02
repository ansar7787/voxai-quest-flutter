import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/branching_dialogue/domain/entities/branching_dialogue_quest.dart';
import 'package:voxai_quest/features/roleplay/branching_dialogue/domain/repositories/branching_dialogue_repository.dart';

class GetBranchingDialogueQuests {
  final BranchingDialogueRepository repository;

  GetBranchingDialogueQuests(this.repository);

  Future<Either<Failure, List<BranchingDialogueQuest>>> call(int level) async {
    return await repository.getBranchingDialogueQuests(level);
  }
}
