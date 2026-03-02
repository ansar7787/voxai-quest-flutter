import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/grammar/grammar_quest/data/models/grammar_quest_quest_model.dart';

abstract class GrammarQuestRemoteDataSource {
  Future<List<GrammarQuestQuestModel>> getGrammarQuestQuests(int level);
}

class GrammarQuestRemoteDataSourceImpl implements GrammarQuestRemoteDataSource {
  final FirebaseFirestore firestore;

  GrammarQuestRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<GrammarQuestQuestModel>> getGrammarQuestQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('grammarQuest')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return GrammarQuestQuestModel.fromJson(questMap);
        }).toList();
      }
      return [GrammarQuestQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for grammarQuest');
    }
  }
}
