import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/grammar/tense_mastery/data/models/tense_mastery_quest_model.dart';

abstract class TenseMasteryRemoteDataSource {
  Future<List<TenseMasteryQuestModel>> getTenseMasteryQuests(int level);
}

class TenseMasteryRemoteDataSourceImpl implements TenseMasteryRemoteDataSource {
  final FirebaseFirestore firestore;

  TenseMasteryRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<TenseMasteryQuestModel>> getTenseMasteryQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('tenseMastery')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return TenseMasteryQuestModel.fromJson(questMap);
        }).toList();
      }
      return [TenseMasteryQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for tenseMastery');
    }
  }
}
