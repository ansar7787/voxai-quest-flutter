import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/listening/emotion_recognition/data/models/emotion_recognition_quest_model.dart';

abstract class EmotionRecognitionRemoteDataSource {
  Future<List<EmotionRecognitionQuestModel>> getQuests(int level);
}

class EmotionRecognitionRemoteDataSourceImpl
    implements EmotionRecognitionRemoteDataSource {
  final FirebaseFirestore firestore;

  EmotionRecognitionRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<EmotionRecognitionQuestModel>> getQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('emotionRecognition')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questData = Map<String, dynamic>.from(q as Map);
          questData['id'] = questData['id'] ?? doc.id;
          return EmotionRecognitionQuestModel.fromJson(questData);
        }).toList();
      }
      final finalData = doc.data()!;
      finalData['id'] = doc.id;
      return [EmotionRecognitionQuestModel.fromJson(finalData)];
    } else {
      throw Exception('Level $level not found for emotionRecognition');
    }
  }
}
