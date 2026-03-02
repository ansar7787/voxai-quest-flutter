import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/writing/essay_drafting/data/models/essay_drafting_quest_model.dart';

abstract class EssayDraftingRemoteDataSource {
  Future<List<EssayDraftingQuestModel>> getEssayDraftingQuests(int level);
}

class EssayDraftingRemoteDataSourceImpl
    implements EssayDraftingRemoteDataSource {
  final FirebaseFirestore firestore;

  EssayDraftingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<EssayDraftingQuestModel>> getEssayDraftingQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('essayDrafting')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return EssayDraftingQuestModel.fromJson(questMap);
        }).toList();
      }
      return [EssayDraftingQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for essayDrafting');
    }
  }
}
