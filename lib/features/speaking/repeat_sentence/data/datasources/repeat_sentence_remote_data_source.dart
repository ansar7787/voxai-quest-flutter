import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/speaking/repeat_sentence/data/models/repeat_sentence_quest_model.dart';

abstract class RepeatSentenceRemoteDataSource {
  Future<List<RepeatSentenceQuestModel>> getRepeatSentenceQuests(int level);
}

class RepeatSentenceRemoteDataSourceImpl
    implements RepeatSentenceRemoteDataSource {
  final FirebaseFirestore firestore;

  RepeatSentenceRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<RepeatSentenceQuestModel>> getRepeatSentenceQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('repeatSentence')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return RepeatSentenceQuestModel.fromJson(questMap);
        }).toList();
      }
      return [RepeatSentenceQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for repeatSentence');
    }
  }
}
