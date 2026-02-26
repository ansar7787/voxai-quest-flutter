import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/vocabulary/data/models/vocabulary_quest_model.dart';

abstract class VocabularyRemoteDataSource {
  Future<List<VocabularyQuestModel>> getVocabularyQuests(
    String gameType,
    int level,
  );
}

class VocabularyRemoteDataSourceImpl implements VocabularyRemoteDataSource {
  final FirebaseFirestore firestore;

  VocabularyRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<VocabularyQuestModel>> getVocabularyQuests(
    String gameType,
    int level,
  ) async {
    final snapshot = await firestore
        .collection('quests')
        .doc(gameType)
        .collection('levels')
        .doc(level.toString())
        .get();

    if (snapshot.exists) {
      final List questsData = snapshot.data()?['quests'] ?? [];
      return questsData.asMap().entries.map((entry) {
        final json = entry.value as Map<String, dynamic>;
        final index = entry.key;
        return VocabularyQuestModel.fromJson(json, '${snapshot.id}_$index');
      }).toList();
    }
    return [];
  }
}
