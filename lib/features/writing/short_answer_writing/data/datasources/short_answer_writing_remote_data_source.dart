import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/writing/short_answer_writing/data/models/short_answer_writing_quest_model.dart';

abstract class ShortAnswerWritingRemoteDataSource {
  Future<List<ShortAnswerWritingQuestModel>> getShortAnswerWritingQuests(
    int level,
  );
}

class ShortAnswerWritingRemoteDataSourceImpl
    implements ShortAnswerWritingRemoteDataSource {
  final FirebaseFirestore firestore;

  ShortAnswerWritingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ShortAnswerWritingQuestModel>> getShortAnswerWritingQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('shortAnswerWriting')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return ShortAnswerWritingQuestModel.fromJson(questMap);
        }).toList();
      }
      return [ShortAnswerWritingQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for shortAnswerWriting');
    }
  }
}
