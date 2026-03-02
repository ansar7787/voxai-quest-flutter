import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/writing/fix_the_sentence/data/models/fix_the_sentence_quest_model.dart';

abstract class FixTheSentenceRemoteDataSource {
  Future<List<FixTheSentenceQuestModel>> getFixTheSentenceQuests(int level);
}

class FixTheSentenceRemoteDataSourceImpl
    implements FixTheSentenceRemoteDataSource {
  final FirebaseFirestore firestore;

  FixTheSentenceRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<FixTheSentenceQuestModel>> getFixTheSentenceQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('fixTheSentence')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return FixTheSentenceQuestModel.fromJson(questMap);
        }).toList();
      }
      return [FixTheSentenceQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for fixTheSentence');
    }
  }
}
