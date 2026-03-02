import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/article_insertion/domain/entities/article_insertion_quest.dart';

abstract class ArticleInsertionRepository {
  Future<Either<Failure, List<ArticleInsertionQuest>>> getArticleInsertionQuests(int level);
}
