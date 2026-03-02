import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/grammar/clause_connector/data/models/clause_connector_quest_model.dart';

abstract class ClauseConnectorRemoteDataSource {
  Future<List<ClauseConnectorQuestModel>> getClauseConnectorQuests(int level);
}

class ClauseConnectorRemoteDataSourceImpl
    implements ClauseConnectorRemoteDataSource {
  final FirebaseFirestore firestore;

  ClauseConnectorRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ClauseConnectorQuestModel>> getClauseConnectorQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('clauseConnector')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return ClauseConnectorQuestModel.fromJson(questMap);
        }).toList();
      }
      return [ClauseConnectorQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for clauseConnector');
    }
  }
}
