import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/listening/audio_true_false/data/models/audio_true_false_quest_model.dart';

abstract class AudioTrueFalseRemoteDataSource {
  Future<List<AudioTrueFalseQuestModel>> getQuests(int level);
}

class AudioTrueFalseRemoteDataSourceImpl
    implements AudioTrueFalseRemoteDataSource {
  final FirebaseFirestore firestore;

  AudioTrueFalseRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<AudioTrueFalseQuestModel>> getQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('audioTrueFalse')
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
          return AudioTrueFalseQuestModel.fromJson(questData);
        }).toList();
      }
      final finalData = doc.data()!;
      finalData['id'] = doc.id;
      return [AudioTrueFalseQuestModel.fromJson(finalData)];
    } else {
      throw Exception('Level $level not found for audioTrueFalse');
    }
  }
}
