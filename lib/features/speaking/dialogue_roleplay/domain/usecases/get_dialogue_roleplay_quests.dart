import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/dialogue_roleplay/domain/entities/dialogue_roleplay_quest.dart';
import 'package:voxai_quest/features/speaking/dialogue_roleplay/domain/repositories/dialogue_roleplay_repository.dart';

class GetDialogueRoleplayQuests {
  final DialogueRoleplayRepository repository;

  GetDialogueRoleplayQuests(this.repository);

  Future<Either<Failure, List<DialogueRoleplayQuest>>> call(int level) async {
    return await repository.getDialogueRoleplayQuests(level);
  }
}
