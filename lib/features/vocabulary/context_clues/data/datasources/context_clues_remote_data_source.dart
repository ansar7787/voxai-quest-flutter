import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/vocabulary/context_clues/data/models/context_clues_quest_model.dart';

abstract class ContextCluesRemoteDataSource {
  Future<List<ContextCluesQuestModel>> getContextCluesQuests(int level);
}

class ContextCluesRemoteDataSourceImpl implements ContextCluesRemoteDataSource {
  final FirebaseFirestore firestore;

  ContextCluesRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ContextCluesQuestModel>> getContextCluesQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('contextClues')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return ContextCluesQuestModel.fromJson(questMap);
        }).toList();
      }
      return [ContextCluesQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for contextClues');
    }
  }
}
