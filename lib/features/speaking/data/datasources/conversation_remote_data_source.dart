import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/features/speaking/data/models/conversation_quest_model.dart';

abstract class ConversationRemoteDataSource {
  Future<ConversationQuestModel> getConversationQuest(int level);
}

class ConversationRemoteDataSourceImpl implements ConversationRemoteDataSource {
  final FirebaseFirestore firestore;

  ConversationRemoteDataSourceImpl({required this.firestore});

  @override
  Future<ConversationQuestModel> getConversationQuest(int level) async {
    try {
      final docId = 'conversation_$level';
      var doc = await firestore
          .collection('conversation_quests')
          .doc(docId)
          .get();

      if (!doc.exists) {
        final snapshot = await firestore
            .collection('conversation_quests')
            .get();
        if (snapshot.docs.isNotEmpty) {
          final randomIndex = (level - 1) % snapshot.docs.length;
          doc = snapshot.docs[randomIndex];
        }
      }

      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        data['difficulty'] = level;
        return ConversationQuestModel.fromJson(data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
