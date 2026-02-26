import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/kids_zone/domain/entities/kids_quest.dart';
import 'package:voxai_quest/features/kids_zone/domain/repositories/kids_repository.dart';

class GetKidsQuests {
  final KidsRepository repository;

  GetKidsQuests(this.repository);

  Future<Either<Failure, List<KidsQuest>>> call(
    String gameType,
    int level,
  ) async {
    return await repository.getQuestsByLevel(gameType, level);
  }
}
