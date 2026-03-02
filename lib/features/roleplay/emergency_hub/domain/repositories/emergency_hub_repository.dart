import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/emergency_hub/domain/entities/emergency_hub_quest.dart';

abstract class EmergencyHubRepository {
  Future<Either<Failure, List<EmergencyHubQuest>>> getEmergencyHubQuests(int level);
}
