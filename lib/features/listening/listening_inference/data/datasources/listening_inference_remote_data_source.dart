import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/listening/listening_inference/data/models/listening_inference_quest_model.dart';

abstract class ListeningInferenceRemoteDataSource {
  Future<List<ListeningInferenceQuestModel>> getQuests(int level);
}

class ListeningInferenceRemoteDataSourceImpl
    implements ListeningInferenceRemoteDataSource {
  final FirebaseFirestore firestore;

  ListeningInferenceRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ListeningInferenceQuestModel>> getQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('listeningInference')
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
          return ListeningInferenceQuestModel.fromJson(questData);
        }).toList();
      }
      final finalData = doc.data()!;
      finalData['id'] = doc.id;
      return [ListeningInferenceQuestModel.fromJson(finalData)];
    } else {
      throw Exception('Level $level not found for listeningInference');
    }
  }
}
