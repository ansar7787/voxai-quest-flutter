import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/writing/writing_email/data/models/writing_email_quest_model.dart';

abstract class WritingEmailRemoteDataSource {
  Future<List<WritingEmailQuestModel>> getWritingEmailQuests(int level);
}

class WritingEmailRemoteDataSourceImpl implements WritingEmailRemoteDataSource {
  final FirebaseFirestore firestore;

  WritingEmailRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<WritingEmailQuestModel>> getWritingEmailQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('writingEmail')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return WritingEmailQuestModel.fromJson(questMap);
        }).toList();
      }
      return [WritingEmailQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for writingEmail');
    }
  }
}
