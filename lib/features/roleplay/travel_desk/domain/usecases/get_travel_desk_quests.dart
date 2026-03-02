import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/travel_desk/domain/entities/travel_desk_quest.dart';
import 'package:voxai_quest/features/roleplay/travel_desk/domain/repositories/travel_desk_repository.dart';

class GetTravelDeskQuests {
  final TravelDeskRepository repository;

  GetTravelDeskQuests(this.repository);

  Future<Either<Failure, List<TravelDeskQuest>>> call(int level) async {
    return await repository.getTravelDeskQuests(level);
  }
}
