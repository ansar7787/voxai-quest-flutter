import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/reading/guess_title/data/models/guess_title_quest_model.dart';

abstract class GuessTitleRemoteDataSource {
  Future<List<GuessTitleQuestModel>> getGuessTitleQuests(int level);
}

class GuessTitleRemoteDataSourceImpl implements GuessTitleRemoteDataSource {
  final FirebaseFirestore firestore;

  GuessTitleRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<GuessTitleQuestModel>> getGuessTitleQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('guessTitle')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return GuessTitleQuestModel.fromJson(questMap);
        }).toList();
      }
      return [GuessTitleQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for guessTitle');
    }
  }
}
