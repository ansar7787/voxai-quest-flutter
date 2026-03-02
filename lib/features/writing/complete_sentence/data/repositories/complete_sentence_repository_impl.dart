import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/writing/complete_sentence/data/datasources/complete_sentence_remote_data_source.dart';
import 'package:voxai_quest/features/writing/complete_sentence/domain/entities/complete_sentence_quest.dart';
import 'package:voxai_quest/features/writing/complete_sentence/domain/repositories/complete_sentence_repository.dart';

class CompleteSentenceRepositoryImpl implements CompleteSentenceRepository {
  final CompleteSentenceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CompleteSentenceRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CompleteSentenceQuest>>> getCompleteSentenceQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getCompleteSentenceQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

