import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/writing/complete_sentence/data/models/complete_sentence_quest_model.dart';

abstract class CompleteSentenceRemoteDataSource {
  Future<List<CompleteSentenceQuestModel>> getCompleteSentenceQuests(int level);
}

class CompleteSentenceRemoteDataSourceImpl
    implements CompleteSentenceRemoteDataSource {
  final FirebaseFirestore firestore;

  CompleteSentenceRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<CompleteSentenceQuestModel>> getCompleteSentenceQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('completeSentence')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return CompleteSentenceQuestModel.fromJson(questMap);
        }).toList();
      }
      return [CompleteSentenceQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for completeSentence');
    }
  }
}
