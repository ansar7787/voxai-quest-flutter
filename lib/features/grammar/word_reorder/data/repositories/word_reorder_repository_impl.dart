import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/grammar/word_reorder/data/datasources/word_reorder_remote_data_source.dart';
import 'package:voxai_quest/features/grammar/word_reorder/domain/entities/word_reorder_quest.dart';
import 'package:voxai_quest/features/grammar/word_reorder/domain/repositories/word_reorder_repository.dart';

class WordReorderRepositoryImpl implements WordReorderRepository {
  final WordReorderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WordReorderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<WordReorderQuest>>> getWordReorderQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getWordReorderQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}
