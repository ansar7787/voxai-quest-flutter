import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/speaking/pronunciation_focus/data/models/pronunciation_focus_quest_model.dart';

abstract class PronunciationFocusRemoteDataSource {
  Future<List<PronunciationFocusQuestModel>> getPronunciationFocusQuests(
    int level,
  );
}

class PronunciationFocusRemoteDataSourceImpl
    implements PronunciationFocusRemoteDataSource {
  final FirebaseFirestore firestore;

  PronunciationFocusRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<PronunciationFocusQuestModel>> getPronunciationFocusQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('pronunciationFocus')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return PronunciationFocusQuestModel.fromJson(questMap);
        }).toList();
      }
      return [PronunciationFocusQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for pronunciationFocus');
    }
  }
}
