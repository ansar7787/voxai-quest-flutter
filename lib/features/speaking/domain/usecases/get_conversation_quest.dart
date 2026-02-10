import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/domain/entities/conversation_quest.dart';
import 'package:voxai_quest/features/speaking/domain/repositories/conversation_repository.dart';

class GetConversationQuest {
  final ConversationRepository repository;

  GetConversationQuest(this.repository);

  Future<Either<Failure, ConversationQuest>> call(int difficulty) async {
    return await repository.getConversationQuest(difficulty);
  }
}
