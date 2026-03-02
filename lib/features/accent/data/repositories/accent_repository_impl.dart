import '../../domain/entities/accent_quest.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/game_quest.dart';
import '../../domain/repositories/accent_repository.dart';
import '../datasources/accent_remote_data_source.dart';
import '../../../../core/network/network_info.dart';

class AccentRepositoryImpl implements AccentRepository {
  final AccentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AccentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

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
      return Left(ServerFailure(e.toString()));
    }
  }
}
