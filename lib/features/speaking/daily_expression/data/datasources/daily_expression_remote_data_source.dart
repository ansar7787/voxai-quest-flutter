import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/speaking/daily_expression/data/models/daily_expression_quest_model.dart';

abstract class DailyExpressionRemoteDataSource {
  Future<List<DailyExpressionQuestModel>> getDailyExpressionQuests(int level);
}

class DailyExpressionRemoteDataSourceImpl
    implements DailyExpressionRemoteDataSource {
  final FirebaseFirestore firestore;

  DailyExpressionRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<DailyExpressionQuestModel>> getDailyExpressionQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('dailyExpression')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return DailyExpressionQuestModel.fromJson(questMap);
        }).toList();
      }
      return [DailyExpressionQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for dailyExpression');
    }
  }
}
