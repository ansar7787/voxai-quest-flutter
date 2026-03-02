import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/writing/daily_journal/data/models/daily_journal_quest_model.dart';

abstract class DailyJournalRemoteDataSource {
  Future<List<DailyJournalQuestModel>> getDailyJournalQuests(int level);
}

class DailyJournalRemoteDataSourceImpl implements DailyJournalRemoteDataSource {
  final FirebaseFirestore firestore;

  DailyJournalRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<DailyJournalQuestModel>> getDailyJournalQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('dailyJournal')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return DailyJournalQuestModel.fromJson(questMap);
        }).toList();
      }
      return [DailyJournalQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for dailyJournal');
    }
  }
}
