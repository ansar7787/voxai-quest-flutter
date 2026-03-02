import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/detail_spotlight/domain/entities/detail_spotlight_quest.dart';

abstract class DetailSpotlightRepository {
  Future<Either<Failure, List<DetailSpotlightQuest>>> getQuests(int level);
}
