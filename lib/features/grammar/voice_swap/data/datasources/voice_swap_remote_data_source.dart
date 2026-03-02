import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/grammar/voice_swap/data/models/voice_swap_quest_model.dart';

abstract class VoiceSwapRemoteDataSource {
  Future<List<VoiceSwapQuestModel>> getVoiceSwapQuests(int level);
}

class VoiceSwapRemoteDataSourceImpl implements VoiceSwapRemoteDataSource {
  final FirebaseFirestore firestore;

  VoiceSwapRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<VoiceSwapQuestModel>> getVoiceSwapQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('voiceSwap')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return VoiceSwapQuestModel.fromJson(questMap);
        }).toList();
      }
      return [VoiceSwapQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for voiceSwap');
    }
  }
}
