import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/writing/opinion_writing/data/models/opinion_writing_quest_model.dart';

abstract class OpinionWritingRemoteDataSource {
  Future<List<OpinionWritingQuestModel>> getOpinionWritingQuests(int level);
}

class OpinionWritingRemoteDataSourceImpl
    implements OpinionWritingRemoteDataSource {
  final FirebaseFirestore firestore;

  OpinionWritingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<OpinionWritingQuestModel>> getOpinionWritingQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('opinionWriting')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return OpinionWritingQuestModel.fromJson(questMap);
        }).toList();
      }
      return [OpinionWritingQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for opinionWriting');
    }
  }
}
