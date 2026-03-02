import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/emergency_hub/domain/entities/emergency_hub_quest.dart';
import 'package:voxai_quest/features/roleplay/emergency_hub/domain/repositories/emergency_hub_repository.dart';

class GetEmergencyHubQuests {
  final EmergencyHubRepository repository;

  GetEmergencyHubQuests(this.repository);

  Future<Either<Failure, List<EmergencyHubQuest>>> call(int level) async {
    return await repository.getEmergencyHubQuests(level);
  }
}
