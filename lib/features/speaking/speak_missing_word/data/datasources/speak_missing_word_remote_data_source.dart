import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/speaking/speak_missing_word/data/models/speak_missing_word_quest_model.dart';

abstract class SpeakMissingWordRemoteDataSource {
  Future<List<SpeakMissingWordQuestModel>> getSpeakMissingWordQuests(int level);
}

class SpeakMissingWordRemoteDataSourceImpl
    implements SpeakMissingWordRemoteDataSource {
  final FirebaseFirestore firestore;

  SpeakMissingWordRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SpeakMissingWordQuestModel>> getSpeakMissingWordQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('speakMissingWord')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return SpeakMissingWordQuestModel.fromJson(questMap);
        }).toList();
      }
      return [SpeakMissingWordQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for speakMissingWord');
    }
  }
}
