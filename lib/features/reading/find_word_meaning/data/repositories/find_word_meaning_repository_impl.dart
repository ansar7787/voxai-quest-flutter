import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/reading/find_word_meaning/data/datasources/find_word_meaning_remote_data_source.dart';
import 'package:voxai_quest/features/reading/find_word_meaning/domain/entities/find_word_meaning_quest.dart';
import 'package:voxai_quest/features/reading/find_word_meaning/domain/repositories/find_word_meaning_repository.dart';

class FindWordMeaningRepositoryImpl implements FindWordMeaningRepository {
  final FindWordMeaningRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FindWordMeaningRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<FindWordMeaningQuest>>> getFindWordMeaningQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getFindWordMeaningQuests(
          level,
        );
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}
