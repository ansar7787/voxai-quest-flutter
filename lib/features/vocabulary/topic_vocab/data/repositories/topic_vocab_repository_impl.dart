import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/vocabulary/topic_vocab/data/datasources/topic_vocab_remote_data_source.dart';
import 'package:voxai_quest/features/vocabulary/topic_vocab/domain/entities/topic_vocab_quest.dart';
import 'package:voxai_quest/features/vocabulary/topic_vocab/domain/repositories/topic_vocab_repository.dart';

class TopicVocabRepositoryImpl implements TopicVocabRepository {
  final TopicVocabRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TopicVocabRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TopicVocabQuest>>> getTopicVocabQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getTopicVocabQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}
