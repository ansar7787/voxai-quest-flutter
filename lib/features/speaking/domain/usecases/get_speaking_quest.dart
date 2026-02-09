import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/speaking/domain/entities/speaking_quest.dart';
import 'package:voxai_quest/features/speaking/domain/repositories/speaking_repository.dart';

class GetSpeakingQuest implements UseCase<SpeakingQuest, int> {
  final SpeakingRepository repository;

  GetSpeakingQuest(this.repository);

  @override
  Future<Either<Failure, SpeakingQuest>> call(int difficulty) async {
    return await repository.getSpeakingQuest(difficulty);
  }
}
