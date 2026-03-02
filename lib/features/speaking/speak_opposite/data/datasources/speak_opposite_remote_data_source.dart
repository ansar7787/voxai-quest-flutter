import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/speaking/speak_opposite/data/models/speak_opposite_quest_model.dart';

abstract class SpeakOppositeRemoteDataSource {
  Future<List<SpeakOppositeQuestModel>> getSpeakOppositeQuests(int level);
}

class SpeakOppositeRemoteDataSourceImpl
    implements SpeakOppositeRemoteDataSource {
  final FirebaseFirestore firestore;

  SpeakOppositeRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SpeakOppositeQuestModel>> getSpeakOppositeQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('speakOpposite')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return SpeakOppositeQuestModel.fromJson(questMap);
        }).toList();
      }
      return [SpeakOppositeQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for speakOpposite');
    }
  }
}
