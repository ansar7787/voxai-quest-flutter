import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/vocabulary/topic_vocab/data/models/topic_vocab_quest_model.dart';

abstract class TopicVocabRemoteDataSource {
  Future<List<TopicVocabQuestModel>> getTopicVocabQuests(int level);
}

class TopicVocabRemoteDataSourceImpl implements TopicVocabRemoteDataSource {
  final FirebaseFirestore firestore;

  TopicVocabRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<TopicVocabQuestModel>> getTopicVocabQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('topicVocab')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return TopicVocabQuestModel.fromJson(questMap);
        }).toList();
      }
      return [TopicVocabQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for topicVocab');
    }
  }
}
