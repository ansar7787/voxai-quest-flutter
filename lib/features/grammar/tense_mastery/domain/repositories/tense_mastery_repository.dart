import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/tense_mastery/domain/entities/tense_mastery_quest.dart';

abstract class TenseMasteryRepository {
  Future<Either<Failure, List<TenseMasteryQuest>>> getTenseMasteryQuests(
    int level,
  );
}
