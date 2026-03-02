import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/article_insertion/domain/entities/article_insertion_quest.dart';
import 'package:voxai_quest/features/grammar/article_insertion/domain/repositories/article_insertion_repository.dart';

class GetArticleInsertionQuests {
  final ArticleInsertionRepository repository;

  GetArticleInsertionQuests(this.repository);

  Future<Either<Failure, List<ArticleInsertionQuest>>> call(int level) async {
    return await repository.getArticleInsertionQuests(level);
  }
}
