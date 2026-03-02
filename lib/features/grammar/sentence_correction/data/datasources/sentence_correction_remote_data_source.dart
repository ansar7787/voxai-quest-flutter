import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/grammar/sentence_correction/data/models/sentence_correction_quest_model.dart';

abstract class SentenceCorrectionRemoteDataSource {
  Future<List<SentenceCorrectionQuestModel>> getSentenceCorrectionQuests(
    int level,
  );
}

class SentenceCorrectionRemoteDataSourceImpl
    implements SentenceCorrectionRemoteDataSource {
  final FirebaseFirestore firestore;

  SentenceCorrectionRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SentenceCorrectionQuestModel>> getSentenceCorrectionQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('sentenceCorrection')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return SentenceCorrectionQuestModel.fromJson(questMap);
        }).toList();
      }
      return [SentenceCorrectionQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for sentenceCorrection');
    }
  }
}
