import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/core/data/services/asset_quest_service.dart';
import 'package:voxai_quest/features/reading/read_and_answer/data/models/read_and_answer_quest_model.dart';

abstract class ReadAndAnswerRemoteDataSource {
  Future<List<ReadAndAnswerQuestModel>> getReadAndAnswerQuests(int level);
}

class ReadAndAnswerRemoteDataSourceImpl
    implements ReadAndAnswerRemoteDataSource {
  final FirebaseFirestore firestore;
  final AssetQuestService assetQuestService;

  ReadAndAnswerRemoteDataSourceImpl({
    required this.firestore,
    required this.assetQuestService,
  });

  @override
  Future<List<ReadAndAnswerQuestModel>> getReadAndAnswerQuests(
    int level,
  ) async {
    // 1. Try to load from Local Assets (Free & Fast)
    final localData = await assetQuestService.getQuests('readAndAnswer', level);
    if (localData.isNotEmpty) {
      return localData.map((q) => ReadAndAnswerQuestModel.fromJson(q)).toList();
    }

    // 2. Fallback to Firestore (Cloud)
    final doc = await firestore
        .collection('quests')
        .doc('readAndAnswer')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return ReadAndAnswerQuestModel.fromJson(questMap);
        }).toList();
      }
      return [ReadAndAnswerQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for readAndAnswer');
    }
  }
}
