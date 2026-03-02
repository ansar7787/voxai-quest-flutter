import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/grammar/article_insertion/data/models/article_insertion_quest_model.dart';

abstract class ArticleInsertionRemoteDataSource {
  Future<List<ArticleInsertionQuestModel>> getArticleInsertionQuests(int level);
}

class ArticleInsertionRemoteDataSourceImpl
    implements ArticleInsertionRemoteDataSource {
  final FirebaseFirestore firestore;

  ArticleInsertionRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ArticleInsertionQuestModel>> getArticleInsertionQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('articleInsertion')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return ArticleInsertionQuestModel.fromJson(questMap);
        }).toList();
      }
      return [ArticleInsertionQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for articleInsertion');
    }
  }
}
