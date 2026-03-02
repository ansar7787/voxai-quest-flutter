import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/reading/paragraph_summary/data/models/paragraph_summary_quest_model.dart';

abstract class ParagraphSummaryRemoteDataSource {
  Future<List<ParagraphSummaryQuestModel>> getParagraphSummaryQuests(int level);
}

class ParagraphSummaryRemoteDataSourceImpl
    implements ParagraphSummaryRemoteDataSource {
  final FirebaseFirestore firestore;

  ParagraphSummaryRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ParagraphSummaryQuestModel>> getParagraphSummaryQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('paragraphSummary')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return ParagraphSummaryQuestModel.fromJson(questMap);
        }).toList();
      }
      return [ParagraphSummaryQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for paragraphSummary');
    }
  }
}
