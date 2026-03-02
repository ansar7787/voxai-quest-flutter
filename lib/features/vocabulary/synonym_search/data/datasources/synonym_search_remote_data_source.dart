import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/vocabulary/synonym_search/data/models/synonym_search_quest_model.dart';

abstract class SynonymSearchRemoteDataSource {
  Future<List<SynonymSearchQuestModel>> getSynonymSearchQuests(int level);
}

class SynonymSearchRemoteDataSourceImpl
    implements SynonymSearchRemoteDataSource {
  final FirebaseFirestore firestore;

  SynonymSearchRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SynonymSearchQuestModel>> getSynonymSearchQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('synonymSearch')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return SynonymSearchQuestModel.fromJson(questMap);
        }).toList();
      }
      return [SynonymSearchQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for synonymSearch');
    }
  }
}
