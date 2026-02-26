import '../../domain/entities/roleplay_quest.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/game_quest.dart';
import '../../domain/repositories/roleplay_repository.dart';

class RoleplayRepositoryImpl implements RoleplayRepository {
  final dynamic remoteDataSource;
  final dynamic networkInfo;
  RoleplayRepositoryImpl({this.remoteDataSource, this.networkInfo});

  @override
  Future<Either<Failure, List<RoleplayQuest>>> getRoleplayQuests({
    required GameSubtype gameType,
    required int level,
  }) async {
    try {
      final remoteQuests = await remoteDataSource.getRoleplayQuest(
        gameType: gameType,
        level: level,
      );
      return Right(remoteQuests);
    } catch (e) {
      return const Left(
        ServerFailure(
          "Failed to connect to the server. Please check your internet connection.",
        ),
      );
    }
  }
}
