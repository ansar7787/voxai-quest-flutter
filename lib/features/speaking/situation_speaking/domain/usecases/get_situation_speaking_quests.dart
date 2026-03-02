import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/situation_speaking/domain/entities/situation_speaking_quest.dart';
import 'package:voxai_quest/features/speaking/situation_speaking/domain/repositories/situation_speaking_repository.dart';

class GetSituationSpeakingQuests {
  final SituationSpeakingRepository repository;

  GetSituationSpeakingQuests(this.repository);

  Future<Either<Failure, List<SituationSpeakingQuest>>> call(int level) async {
    return await repository.getSituationSpeakingQuests(level);
  }
}
