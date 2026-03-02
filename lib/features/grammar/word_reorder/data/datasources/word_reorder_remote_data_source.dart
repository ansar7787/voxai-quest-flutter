import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/grammar/word_reorder/data/models/word_reorder_quest_model.dart';

abstract class WordReorderRemoteDataSource {
  Future<List<WordReorderQuestModel>> getWordReorderQuests(int level);
}

class WordReorderRemoteDataSourceImpl implements WordReorderRemoteDataSource {
  final FirebaseFirestore firestore;

  WordReorderRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<WordReorderQuestModel>> getWordReorderQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('wordReorder')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return WordReorderQuestModel.fromJson(questMap);
        }).toList();
      }
      return [WordReorderQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for wordReorder');
    }
  }
}
