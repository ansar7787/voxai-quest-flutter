import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';

abstract class LeaderboardRepository {
  Future<Either<Failure, List<UserEntity>>> getTopUsers({int limit = 10});
}
