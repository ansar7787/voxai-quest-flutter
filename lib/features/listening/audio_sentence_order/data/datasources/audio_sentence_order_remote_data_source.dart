import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/listening/audio_sentence_order/data/models/audio_sentence_order_quest_model.dart';

abstract class AudioSentenceOrderRemoteDataSource {
  Future<List<AudioSentenceOrderQuestModel>> getQuests(int level);
}

class AudioSentenceOrderRemoteDataSourceImpl
    implements AudioSentenceOrderRemoteDataSource {
  final FirebaseFirestore firestore;

  AudioSentenceOrderRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<AudioSentenceOrderQuestModel>> getQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('audioSentenceOrder')
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
          return AudioSentenceOrderQuestModel.fromJson(questData);
        }).toList();
      }
      final finalData = doc.data()!;
      finalData['id'] = doc.id;
      return [AudioSentenceOrderQuestModel.fromJson(finalData)];
    } else {
      throw Exception('Level $level not found for audioSentenceOrder');
    }
  }
}
