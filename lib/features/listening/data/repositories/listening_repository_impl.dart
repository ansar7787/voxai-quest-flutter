import '../../domain/entities/listening_quest.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/game_quest.dart';
import '../../domain/repositories/listening_repository.dart';

class ListeningRepositoryImpl implements ListeningRepository {
  final dynamic remoteDataSource;
  final dynamic networkInfo;
  ListeningRepositoryImpl({this.remoteDataSource, this.networkInfo});

  @override
  Future<Either<Failure, List<ListeningQuest>>> getListeningQuests({
    required GameSubtype gameType,
    required int level,
  }) async {
    try {
      final remoteQuests = await remoteDataSource.getListeningQuest(
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
