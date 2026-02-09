import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/features/speaking/data/models/speaking_quest_model.dart';

abstract class SpeakingRemoteDataSource {
  Future<SpeakingQuestModel> getSpeakingQuest(int level);
}

class SpeakingRemoteDataSourceImpl implements SpeakingRemoteDataSource {
  final FirebaseFirestore firestore;

  SpeakingRemoteDataSourceImpl(this.firestore);

  @override
  Future<SpeakingQuestModel> getSpeakingQuest(int level) async {
    try {
      final docId = 'speaking_$level';
      var doc = await firestore.collection('speaking_quests').doc(docId).get();

      if (!doc.exists) {
        final fallbackId = 'speaking_${((level - 1) % 5) + 1}';
        doc = await firestore
            .collection('speaking_quests')
            .doc(fallbackId)
            .get();
      }

      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = docId;
        data['difficulty'] = level;
        return SpeakingQuestModel.fromJson(data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
