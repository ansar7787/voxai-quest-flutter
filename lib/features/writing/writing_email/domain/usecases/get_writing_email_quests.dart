import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/writing_email/domain/entities/writing_email_quest.dart';
import 'package:voxai_quest/features/writing/writing_email/domain/repositories/writing_email_repository.dart';

class GetWritingEmailQuests {
  final WritingEmailRepository repository;

  GetWritingEmailQuests(this.repository);

  Future<Either<Failure, List<WritingEmailQuest>>> call(int level) async {
    return await repository.getWritingEmailQuests(level);
  }
}
