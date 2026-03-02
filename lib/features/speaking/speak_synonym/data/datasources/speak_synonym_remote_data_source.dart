import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/speaking/speak_synonym/data/models/speak_synonym_quest_model.dart';

abstract class SpeakSynonymRemoteDataSource {
  Future<List<SpeakSynonymQuestModel>> getSpeakSynonymQuests(int level);
}

class SpeakSynonymRemoteDataSourceImpl implements SpeakSynonymRemoteDataSource {
  final FirebaseFirestore firestore;

  SpeakSynonymRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SpeakSynonymQuestModel>> getSpeakSynonymQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('speakSynonym')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return SpeakSynonymQuestModel.fromJson(questMap);
        }).toList();
      }
      return [SpeakSynonymQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for speakSynonym');
    }
  }
}
