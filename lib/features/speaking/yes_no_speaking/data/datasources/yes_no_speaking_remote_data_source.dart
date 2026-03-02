import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/speaking/yes_no_speaking/data/models/yes_no_speaking_quest_model.dart';

abstract class YesNoSpeakingRemoteDataSource {
  Future<List<YesNoSpeakingQuestModel>> getYesNoSpeakingQuests(int level);
}

class YesNoSpeakingRemoteDataSourceImpl
    implements YesNoSpeakingRemoteDataSource {
  final FirebaseFirestore firestore;

  YesNoSpeakingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<YesNoSpeakingQuestModel>> getYesNoSpeakingQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('yesNoSpeaking')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return YesNoSpeakingQuestModel.fromJson(questMap);
        }).toList();
      }
      return [YesNoSpeakingQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for yesNoSpeaking');
    }
  }
}
