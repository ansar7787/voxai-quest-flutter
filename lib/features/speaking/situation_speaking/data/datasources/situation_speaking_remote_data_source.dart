import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/speaking/situation_speaking/data/models/situation_speaking_quest_model.dart';

abstract class SituationSpeakingRemoteDataSource {
  Future<List<SituationSpeakingQuestModel>> getSituationSpeakingQuests(
    int level,
  );
}

class SituationSpeakingRemoteDataSourceImpl
    implements SituationSpeakingRemoteDataSource {
  final FirebaseFirestore firestore;

  SituationSpeakingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SituationSpeakingQuestModel>> getSituationSpeakingQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('situationSpeaking')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return SituationSpeakingQuestModel.fromJson(questMap);
        }).toList();
      }
      return [SituationSpeakingQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for situationSpeaking');
    }
  }
}
