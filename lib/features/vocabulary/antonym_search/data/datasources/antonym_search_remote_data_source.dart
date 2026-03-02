import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/vocabulary/antonym_search/data/models/antonym_search_quest_model.dart';

abstract class AntonymSearchRemoteDataSource {
  Future<List<AntonymSearchQuestModel>> getAntonymSearchQuests(int level);
}

class AntonymSearchRemoteDataSourceImpl
    implements AntonymSearchRemoteDataSource {
  final FirebaseFirestore firestore;

  AntonymSearchRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<AntonymSearchQuestModel>> getAntonymSearchQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('antonymSearch')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return AntonymSearchQuestModel.fromJson(questMap);
        }).toList();
      }
      return [AntonymSearchQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for antonymSearch');
    }
  }
}
