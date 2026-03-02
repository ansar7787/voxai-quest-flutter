import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/writing/describe_situation_writing/data/models/describe_situation_writing_quest_model.dart';

abstract class DescribeSituationWritingRemoteDataSource {
  Future<List<DescribeSituationWritingQuestModel>>
  getDescribeSituationWritingQuests(int level);
}

class DescribeSituationWritingRemoteDataSourceImpl
    implements DescribeSituationWritingRemoteDataSource {
  final FirebaseFirestore firestore;

  DescribeSituationWritingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<DescribeSituationWritingQuestModel>>
  getDescribeSituationWritingQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('describeSituationWriting')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return DescribeSituationWritingQuestModel.fromJson(questMap);
        }).toList();
      }
      return [DescribeSituationWritingQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for describeSituationWriting');
    }
  }
}
