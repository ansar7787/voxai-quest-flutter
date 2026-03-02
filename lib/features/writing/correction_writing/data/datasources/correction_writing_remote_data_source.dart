import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/writing/correction_writing/data/models/correction_writing_quest_model.dart';

abstract class CorrectionWritingRemoteDataSource {
  Future<List<CorrectionWritingQuestModel>> getCorrectionWritingQuests(
    int level,
  );
}

class CorrectionWritingRemoteDataSourceImpl
    implements CorrectionWritingRemoteDataSource {
  final FirebaseFirestore firestore;

  CorrectionWritingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<CorrectionWritingQuestModel>> getCorrectionWritingQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('correctionWriting')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return CorrectionWritingQuestModel.fromJson(questMap);
        }).toList();
      }
      return [CorrectionWritingQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for correctionWriting');
    }
  }
}
