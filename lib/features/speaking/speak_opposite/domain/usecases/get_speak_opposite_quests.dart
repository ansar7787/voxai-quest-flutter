import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/speak_opposite/domain/entities/speak_opposite_quest.dart';
import 'package:voxai_quest/features/speaking/speak_opposite/domain/repositories/speak_opposite_repository.dart';

class GetSpeakOppositeQuests {
  final SpeakOppositeRepository repository;

  GetSpeakOppositeQuests(this.repository);

  Future<Either<Failure, List<SpeakOppositeQuest>>> call(int level) async {
    return await repository.getSpeakOppositeQuests(level);
  }
}
