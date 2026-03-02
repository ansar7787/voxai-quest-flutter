import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/ambient_id/domain/entities/ambient_id_quest.dart';
import 'package:voxai_quest/features/listening/ambient_id/domain/repositories/ambient_id_repository.dart';

class GetAmbientIdQuests {
  final AmbientIdRepository repository;

  GetAmbientIdQuests(this.repository);

  Future<Either<Failure, List<AmbientIdQuest>>> call(int level) {
    return repository.getQuests(level);
  }
}
