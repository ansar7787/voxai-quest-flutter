import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/writing/summarize_story_writing/data/models/summarize_story_writing_quest_model.dart';

abstract class SummarizeStoryWritingRemoteDataSource {
  Future<List<SummarizeStoryWritingQuestModel>> getSummarizeStoryWritingQuests(
    int level,
  );
}

class SummarizeStoryWritingRemoteDataSourceImpl
    implements SummarizeStoryWritingRemoteDataSource {
  final FirebaseFirestore firestore;

  SummarizeStoryWritingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SummarizeStoryWritingQuestModel>> getSummarizeStoryWritingQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('summarizeStoryWriting')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return SummarizeStoryWritingQuestModel.fromJson(questMap);
        }).toList();
      }
      return [SummarizeStoryWritingQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for summarizeStoryWriting');
    }
  }
}
