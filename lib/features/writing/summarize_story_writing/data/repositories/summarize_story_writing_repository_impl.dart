import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/writing/summarize_story_writing/data/datasources/summarize_story_writing_remote_data_source.dart';
import 'package:voxai_quest/features/writing/summarize_story_writing/domain/entities/summarize_story_writing_quest.dart';
import 'package:voxai_quest/features/writing/summarize_story_writing/domain/repositories/summarize_story_writing_repository.dart';

class SummarizeStoryWritingRepositoryImpl
    implements SummarizeStoryWritingRepository {
  final SummarizeStoryWritingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SummarizeStoryWritingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SummarizeStoryWritingQuest>>>
  getSummarizeStoryWritingQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource
            .getSummarizeStoryWritingQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}
