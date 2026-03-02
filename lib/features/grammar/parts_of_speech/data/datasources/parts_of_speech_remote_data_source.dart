import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/grammar/parts_of_speech/data/models/parts_of_speech_quest_model.dart';

abstract class PartsOfSpeechRemoteDataSource {
  Future<List<PartsOfSpeechQuestModel>> getPartsOfSpeechQuests(int level);
}

class PartsOfSpeechRemoteDataSourceImpl
    implements PartsOfSpeechRemoteDataSource {
  final FirebaseFirestore firestore;

  PartsOfSpeechRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<PartsOfSpeechQuestModel>> getPartsOfSpeechQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('partsOfSpeech')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return PartsOfSpeechQuestModel.fromJson(questMap);
        }).toList();
      }
      return [PartsOfSpeechQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for partsOfSpeech');
    }
  }
}
