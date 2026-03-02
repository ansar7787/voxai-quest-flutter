import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/vocabulary/word_formation/data/datasources/word_formation_remote_data_source.dart';
import 'package:voxai_quest/features/vocabulary/word_formation/domain/entities/word_formation_quest.dart';
import 'package:voxai_quest/features/vocabulary/word_formation/domain/repositories/word_formation_repository.dart';

class WordFormationRepositoryImpl implements WordFormationRepository {
  final WordFormationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WordFormationRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<WordFormationQuest>>> getWordFormationQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getWordFormationQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

