import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/dialogue_roleplay/domain/entities/dialogue_roleplay_quest.dart';

abstract class DialogueRoleplayRepository {
  Future<Either<Failure, List<DialogueRoleplayQuest>>> getDialogueRoleplayQuests(int level);
}
