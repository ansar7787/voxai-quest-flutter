import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/speaking/repeat_sentence/data/datasources/repeat_sentence_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/repeat_sentence/domain/entities/repeat_sentence_quest.dart';
import 'package:voxai_quest/features/speaking/repeat_sentence/domain/repositories/repeat_sentence_repository.dart';

class RepeatSentenceRepositoryImpl implements RepeatSentenceRepository {
  final RepeatSentenceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RepeatSentenceRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<RepeatSentenceQuest>>> getRepeatSentenceQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getRepeatSentenceQuests(
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
