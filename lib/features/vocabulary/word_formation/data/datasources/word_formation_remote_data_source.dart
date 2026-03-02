import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/vocabulary/word_formation/data/models/word_formation_quest_model.dart';

abstract class WordFormationRemoteDataSource {
  Future<List<WordFormationQuestModel>> getWordFormationQuests(int level);
}

class WordFormationRemoteDataSourceImpl
    implements WordFormationRemoteDataSource {
  final FirebaseFirestore firestore;

  WordFormationRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<WordFormationQuestModel>> getWordFormationQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('wordFormation')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return WordFormationQuestModel.fromJson(questMap);
        }).toList();
      }
      return [WordFormationQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for wordFormation');
    }
  }
}
