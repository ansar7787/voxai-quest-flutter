import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/listening/sound_image_match/data/models/sound_image_match_quest_model.dart';

abstract class SoundImageMatchRemoteDataSource {
  Future<List<SoundImageMatchQuestModel>> getQuests(int level);
}

class SoundImageMatchRemoteDataSourceImpl
    implements SoundImageMatchRemoteDataSource {
  final FirebaseFirestore firestore;

  SoundImageMatchRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SoundImageMatchQuestModel>> getQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('soundImageMatch')
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
          return SoundImageMatchQuestModel.fromJson(questData);
        }).toList();
      }
      final finalData = doc.data()!;
      finalData['id'] = doc.id;
      return [SoundImageMatchQuestModel.fromJson(finalData)];
    } else {
      throw Exception('Level $level not found for soundImageMatch');
    }
  }
}
