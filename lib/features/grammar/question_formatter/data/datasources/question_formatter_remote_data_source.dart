import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/grammar/question_formatter/data/models/question_formatter_quest_model.dart';

abstract class QuestionFormatterRemoteDataSource {
  Future<List<QuestionFormatterQuestModel>> getQuestionFormatterQuests(
    int level,
  );
}

class QuestionFormatterRemoteDataSourceImpl
    implements QuestionFormatterRemoteDataSource {
  final FirebaseFirestore firestore;

  QuestionFormatterRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<QuestionFormatterQuestModel>> getQuestionFormatterQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('questionFormatter')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return QuestionFormatterQuestModel.fromJson(questMap);
        }).toList();
      }
      return [QuestionFormatterQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for questionFormatter');
    }
  }
}
