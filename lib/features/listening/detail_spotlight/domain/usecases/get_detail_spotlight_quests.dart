import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/detail_spotlight/domain/entities/detail_spotlight_quest.dart';
import 'package:voxai_quest/features/listening/detail_spotlight/domain/repositories/detail_spotlight_repository.dart';

class GetDetailSpotlightQuests {
  final DetailSpotlightRepository repository;

  GetDetailSpotlightQuests(this.repository);

  Future<Either<Failure, List<DetailSpotlightQuest>>> call(int level) {
    return repository.getQuests(level);
  }
}
