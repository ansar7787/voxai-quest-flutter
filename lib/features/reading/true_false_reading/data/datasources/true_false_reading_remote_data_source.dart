import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/reading/true_false_reading/data/models/true_false_reading_quest_model.dart';

abstract class TrueFalseReadingRemoteDataSource {
  Future<List<TrueFalseReadingQuestModel>> getTrueFalseReadingQuests(int level);
}

class TrueFalseReadingRemoteDataSourceImpl
    implements TrueFalseReadingRemoteDataSource {
  final FirebaseFirestore firestore;

  TrueFalseReadingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<TrueFalseReadingQuestModel>> getTrueFalseReadingQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('trueFalseReading')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return TrueFalseReadingQuestModel.fromJson(questMap);
        }).toList();
      }
      return [TrueFalseReadingQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for trueFalseReading');
    }
  }
}
