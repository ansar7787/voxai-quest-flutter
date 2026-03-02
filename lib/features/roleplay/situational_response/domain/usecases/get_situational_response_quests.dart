import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/situational_response/domain/entities/situational_response_quest.dart';
import 'package:voxai_quest/features/roleplay/situational_response/domain/repositories/situational_response_repository.dart';

class GetSituationalResponseQuests {
  final SituationalResponseRepository repository;

  GetSituationalResponseQuests(this.repository);

  Future<Either<Failure, List<SituationalResponseQuest>>> call(
    int level,
  ) async {
    return await repository.getSituationalResponseQuests(level);
  }
}
