import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/elevator_pitch/domain/entities/elevator_pitch_quest.dart';
import 'package:voxai_quest/features/roleplay/elevator_pitch/domain/repositories/elevator_pitch_repository.dart';

class GetElevatorPitchQuests {
  final ElevatorPitchRepository repository;

  GetElevatorPitchQuests(this.repository);

  Future<Either<Failure, List<ElevatorPitchQuest>>> call(int level) async {
    return await repository.getElevatorPitchQuests(level);
  }
}
