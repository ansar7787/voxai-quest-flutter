import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/features/speaking/data/models/pronunciation_quest_model.dart';

abstract class PronunciationRemoteDataSource {
  Future<PronunciationQuestModel> getPronunciationQuest(int level);
}

class PronunciationRemoteDataSourceImpl
    implements PronunciationRemoteDataSource {
  final FirebaseFirestore firestore;

  PronunciationRemoteDataSourceImpl({required this.firestore});

  @override
  Future<PronunciationQuestModel> getPronunciationQuest(int level) async {
    try {
      final docId = 'pronunciation_$level';
      var doc = await firestore
          .collection('pronunciation_quests')
          .doc(docId)
          .get();

      if (!doc.exists) {
        final snapshot = await firestore
            .collection('pronunciation_quests')
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
        return PronunciationQuestModel.fromJson(data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
