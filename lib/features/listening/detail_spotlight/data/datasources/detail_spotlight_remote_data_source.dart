import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/listening/detail_spotlight/data/models/detail_spotlight_quest_model.dart';

abstract class DetailSpotlightRemoteDataSource {
  Future<List<DetailSpotlightQuestModel>> getQuests(int level);
}

class DetailSpotlightRemoteDataSourceImpl
    implements DetailSpotlightRemoteDataSource {
  final FirebaseFirestore firestore;

  DetailSpotlightRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<DetailSpotlightQuestModel>> getQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('detailSpotlight')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questData = Map<String, dynamic>.from(q as Map);
          questData['id'] = questData['id'] ?? doc.id;
          return DetailSpotlightQuestModel.fromJson(questData);
        }).toList();
      }
      final finalData = doc.data()!;
      finalData['id'] = doc.id;
      return [DetailSpotlightQuestModel.fromJson(finalData)];
    } else {
      throw Exception('Level $level not found for detailSpotlight');
    }
  }
}
