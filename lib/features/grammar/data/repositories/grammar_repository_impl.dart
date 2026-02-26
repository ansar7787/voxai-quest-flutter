import '../../domain/entities/grammar_quest.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/game_quest.dart';
import '../../domain/repositories/grammar_repository.dart';

class GrammarRepositoryImpl implements GrammarRepository {
  final dynamic remoteDataSource;
  final dynamic networkInfo;
  GrammarRepositoryImpl({this.remoteDataSource, this.networkInfo});

  @override
  Future<Either<Failure, List<GrammarQuest>>> getGrammarQuest({
    required GameSubtype gameType,
    required int level,
  }) async {
    try {
      final remoteQuests = await remoteDataSource.getGrammarQuest(
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
