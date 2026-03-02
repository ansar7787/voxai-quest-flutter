import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/speaking/scene_description_speaking/data/models/scene_description_speaking_quest_model.dart';

abstract class SceneDescriptionSpeakingRemoteDataSource {
  Future<List<SceneDescriptionSpeakingQuestModel>>
  getSceneDescriptionSpeakingQuests(int level);
}

class SceneDescriptionSpeakingRemoteDataSourceImpl
    implements SceneDescriptionSpeakingRemoteDataSource {
  final FirebaseFirestore firestore;

  SceneDescriptionSpeakingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SceneDescriptionSpeakingQuestModel>>
  getSceneDescriptionSpeakingQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('sceneDescriptionSpeaking')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return SceneDescriptionSpeakingQuestModel.fromJson(questMap);
        }).toList();
      }
      return [SceneDescriptionSpeakingQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for sceneDescriptionSpeaking');
    }
  }
}
