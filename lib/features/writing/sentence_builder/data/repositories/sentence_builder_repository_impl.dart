import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/writing/sentence_builder/data/datasources/sentence_builder_remote_data_source.dart';
import 'package:voxai_quest/features/writing/sentence_builder/domain/entities/sentence_builder_quest.dart';
import 'package:voxai_quest/features/writing/sentence_builder/domain/repositories/sentence_builder_repository.dart';

class SentenceBuilderRepositoryImpl implements SentenceBuilderRepository {
  final SentenceBuilderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SentenceBuilderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SentenceBuilderQuest>>> getSentenceBuilderQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getSentenceBuilderQuests(
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
