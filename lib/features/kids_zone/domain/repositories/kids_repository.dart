import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/kids_zone/domain/entities/kids_quest.dart';

abstract class KidsRepository {
  Future<Either<Failure, List<KidsQuest>>> getQuestsByLevel(
    String gameType,
    int level,
  );
}
