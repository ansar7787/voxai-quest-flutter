import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/reading/reading_speed_check/data/models/reading_speed_check_quest_model.dart';

abstract class ReadingSpeedCheckRemoteDataSource {
  Future<List<ReadingSpeedCheckQuestModel>> getReadingSpeedCheckQuests(
    int level,
  );
}

class ReadingSpeedCheckRemoteDataSourceImpl
    implements ReadingSpeedCheckRemoteDataSource {
  final FirebaseFirestore firestore;

  ReadingSpeedCheckRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ReadingSpeedCheckQuestModel>> getReadingSpeedCheckQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('readingSpeedCheck')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return ReadingSpeedCheckQuestModel.fromJson(questMap);
        }).toList();
      }
      return [ReadingSpeedCheckQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for readingSpeedCheck');
    }
  }
}
