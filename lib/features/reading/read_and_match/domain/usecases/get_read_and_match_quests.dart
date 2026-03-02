import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/read_and_match/domain/entities/read_and_match_quest.dart';
import 'package:voxai_quest/features/reading/read_and_match/domain/repositories/read_and_match_repository.dart';

class GetReadAndMatchQuests {
  final ReadAndMatchRepository repository;

  GetReadAndMatchQuests(this.repository);

  Future<Either<Failure, List<ReadAndMatchQuest>>> call(int level) async {
    return await repository.getReadAndMatchQuests(level);
  }
}
