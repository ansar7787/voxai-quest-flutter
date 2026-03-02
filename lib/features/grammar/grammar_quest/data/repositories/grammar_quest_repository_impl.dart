import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/grammar/grammar_quest/data/datasources/grammar_quest_remote_data_source.dart';
import 'package:voxai_quest/features/grammar/grammar_quest/domain/entities/grammar_quest_quest.dart';
import 'package:voxai_quest/features/grammar/grammar_quest/domain/repositories/grammar_quest_repository.dart';

class GrammarQuestRepositoryImpl implements GrammarQuestRepository {
  final GrammarQuestRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  GrammarQuestRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<GrammarQuestQuest>>> getGrammarQuestQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getGrammarQuestQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

