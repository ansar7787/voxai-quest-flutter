import '../../domain/entities/accent_quest.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/game_quest.dart';
import '../../domain/repositories/accent_repository.dart';

class AccentRepositoryImpl implements AccentRepository {
  final dynamic remoteDataSource;
  final dynamic networkInfo;
  AccentRepositoryImpl({this.remoteDataSource, this.networkInfo});

  @override
  Future<Either<Failure, List<AccentQuest>>> getAccentQuests({
    required GameSubtype gameType,
    required int level,
  }) async {
    try {
      final remoteQuests = await remoteDataSource.getAccentQuest(
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
