import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/branching_dialogue/domain/entities/branching_dialogue_quest.dart';

abstract class BranchingDialogueRepository {
  Future<Either<Failure, List<BranchingDialogueQuest>>> getBranchingDialogueQuests(int level);
}
