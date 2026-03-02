import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/elevator_pitch/domain/entities/elevator_pitch_quest.dart';

abstract class ElevatorPitchRepository {
  Future<Either<Failure, List<ElevatorPitchQuest>>> getElevatorPitchQuests(
    int level,
  );
}
