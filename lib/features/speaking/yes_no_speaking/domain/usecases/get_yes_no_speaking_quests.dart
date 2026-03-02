import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/yes_no_speaking/domain/entities/yes_no_speaking_quest.dart';
import 'package:voxai_quest/features/speaking/yes_no_speaking/domain/repositories/yes_no_speaking_repository.dart';

class GetYesNoSpeakingQuests {
  final YesNoSpeakingRepository repository;

  GetYesNoSpeakingQuests(this.repository);

  Future<Either<Failure, List<YesNoSpeakingQuest>>> call(int level) async {
    return await repository.getYesNoSpeakingQuests(level);
  }
}
