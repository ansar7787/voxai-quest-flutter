import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/listening/fast_speech_decoder/data/models/fast_speech_decoder_quest_model.dart';

abstract class FastSpeechDecoderRemoteDataSource {
  Future<List<FastSpeechDecoderQuestModel>> getQuests(int level);
}

class FastSpeechDecoderRemoteDataSourceImpl
    implements FastSpeechDecoderRemoteDataSource {
  final FirebaseFirestore firestore;

  FastSpeechDecoderRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<FastSpeechDecoderQuestModel>> getQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('fastSpeechDecoder')
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
          return FastSpeechDecoderQuestModel.fromJson(questData);
        }).toList();
      }
      final finalData = doc.data()!;
      finalData['id'] = doc.id;
      return [FastSpeechDecoderQuestModel.fromJson(finalData)];
    } else {
      throw Exception('Level $level not found for fastSpeechDecoder');
    }
  }
}
