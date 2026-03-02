import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/reading/sentence_order_reading/data/models/sentence_order_reading_quest_model.dart';

abstract class SentenceOrderReadingRemoteDataSource {
  Future<List<SentenceOrderReadingQuestModel>> getSentenceOrderReadingQuests(
    int level,
  );
}

class SentenceOrderReadingRemoteDataSourceImpl
    implements SentenceOrderReadingRemoteDataSource {
  final FirebaseFirestore firestore;

  SentenceOrderReadingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SentenceOrderReadingQuestModel>> getSentenceOrderReadingQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('sentenceOrderReading')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return SentenceOrderReadingQuestModel.fromJson(questMap);
        }).toList();
      }
      return [SentenceOrderReadingQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for sentenceOrderReading');
    }
  }
}
