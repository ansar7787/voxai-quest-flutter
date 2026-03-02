import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/speaking/dialogue_roleplay/data/models/dialogue_roleplay_quest_model.dart';

abstract class DialogueRoleplayRemoteDataSource {
  Future<List<DialogueRoleplayQuestModel>> getDialogueRoleplayQuests(int level);
}

class DialogueRoleplayRemoteDataSourceImpl
    implements DialogueRoleplayRemoteDataSource {
  final FirebaseFirestore firestore;

  DialogueRoleplayRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<DialogueRoleplayQuestModel>> getDialogueRoleplayQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('dialogueRoleplay')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return DialogueRoleplayQuestModel.fromJson(questMap);
        }).toList();
      }
      return [DialogueRoleplayQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for dialogueRoleplay');
    }
  }
}
