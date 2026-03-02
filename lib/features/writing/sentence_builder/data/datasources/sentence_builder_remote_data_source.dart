import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/writing/sentence_builder/data/models/sentence_builder_quest_model.dart';

abstract class SentenceBuilderRemoteDataSource {
  Future<List<SentenceBuilderQuestModel>> getSentenceBuilderQuests(int level);
}

class SentenceBuilderRemoteDataSourceImpl
    implements SentenceBuilderRemoteDataSource {
  final FirebaseFirestore firestore;

  SentenceBuilderRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SentenceBuilderQuestModel>> getSentenceBuilderQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('sentenceBuilder')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return SentenceBuilderQuestModel.fromJson(questMap);
        }).toList();
      }
      return [SentenceBuilderQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for sentenceBuilder');
    }
  }
}
