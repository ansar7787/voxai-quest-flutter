import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/reading/find_word_meaning/data/models/find_word_meaning_quest_model.dart';

abstract class FindWordMeaningRemoteDataSource {
  Future<List<FindWordMeaningQuestModel>> getFindWordMeaningQuests(int level);
}

class FindWordMeaningRemoteDataSourceImpl
    implements FindWordMeaningRemoteDataSource {
  final FirebaseFirestore firestore;

  FindWordMeaningRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<FindWordMeaningQuestModel>> getFindWordMeaningQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('findWordMeaning')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return FindWordMeaningQuestModel.fromJson(questMap);
        }).toList();
      }
      return [FindWordMeaningQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for findWordMeaning');
    }
  }
}
