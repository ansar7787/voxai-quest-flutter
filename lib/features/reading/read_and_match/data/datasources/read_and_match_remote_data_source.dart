import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/reading/read_and_match/data/models/read_and_match_quest_model.dart';

abstract class ReadAndMatchRemoteDataSource {
  Future<List<ReadAndMatchQuestModel>> getReadAndMatchQuests(int level);
}

class ReadAndMatchRemoteDataSourceImpl implements ReadAndMatchRemoteDataSource {
  final FirebaseFirestore firestore;

  ReadAndMatchRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ReadAndMatchQuestModel>> getReadAndMatchQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('readAndMatch')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return ReadAndMatchQuestModel.fromJson(questMap);
        }).toList();
      }
      return [ReadAndMatchQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for readAndMatch');
    }
  }
}
