import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/tense_mastery/domain/entities/tense_mastery_quest.dart';
import 'package:voxai_quest/features/grammar/tense_mastery/domain/repositories/tense_mastery_repository.dart';

class GetTenseMasteryQuests {
  final TenseMasteryRepository repository;

  GetTenseMasteryQuests(this.repository);

  Future<Either<Failure, List<TenseMasteryQuest>>> call(int level) async {
    return await repository.getTenseMasteryQuests(level);
  }
}
