import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/domain/entities/conversation_quest.dart';

abstract class ConversationRepository {
  Future<Either<Failure, ConversationQuest>> getConversationQuest(
    int difficulty,
  );
}
