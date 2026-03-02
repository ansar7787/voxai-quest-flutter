import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/grammar/article_insertion/data/datasources/article_insertion_remote_data_source.dart';
import 'package:voxai_quest/features/grammar/article_insertion/domain/entities/article_insertion_quest.dart';
import 'package:voxai_quest/features/grammar/article_insertion/domain/repositories/article_insertion_repository.dart';

class ArticleInsertionRepositoryImpl implements ArticleInsertionRepository {
  final ArticleInsertionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ArticleInsertionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ArticleInsertionQuest>>>
  getArticleInsertionQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getArticleInsertionQuests(
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
