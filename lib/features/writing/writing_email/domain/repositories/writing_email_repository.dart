import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/writing_email/domain/entities/writing_email_quest.dart';

abstract class WritingEmailRepository {
  Future<Either<Failure, List<WritingEmailQuest>>> getWritingEmailQuests(int level);
}
