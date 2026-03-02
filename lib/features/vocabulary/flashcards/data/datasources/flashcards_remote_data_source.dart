import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/vocabulary/flashcards/data/models/flashcards_quest_model.dart';

abstract class FlashcardsRemoteDataSource {
  Future<List<FlashcardsQuestModel>> getFlashcardsQuests(int level);
}

class FlashcardsRemoteDataSourceImpl implements FlashcardsRemoteDataSource {
  final FirebaseFirestore firestore;

  FlashcardsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<FlashcardsQuestModel>> getFlashcardsQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('flashcards')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return FlashcardsQuestModel.fromJson(questMap);
        }).toList();
      }
      return [FlashcardsQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for flashcards');
    }
  }
}
