import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/vocabulary/idioms/data/models/idioms_quest_model.dart';

abstract class IdiomsRemoteDataSource {
  Future<List<IdiomsQuestModel>> getIdiomsQuests(int level);
}

class IdiomsRemoteDataSourceImpl implements IdiomsRemoteDataSource {
  final FirebaseFirestore firestore;

  IdiomsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<IdiomsQuestModel>> getIdiomsQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('idioms')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return IdiomsQuestModel.fromJson(questMap);
        }).toList();
      }
      return [IdiomsQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for idioms');
    }
  }
}
