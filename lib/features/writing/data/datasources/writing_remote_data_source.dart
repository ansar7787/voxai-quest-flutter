import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/features/writing/data/models/writing_quest_model.dart';

abstract class WritingRemoteDataSource {
  Future<WritingQuestModel> getWritingQuest(int level);
}

class WritingRemoteDataSourceImpl implements WritingRemoteDataSource {
  final FirebaseFirestore firestore;

  WritingRemoteDataSourceImpl(this.firestore);

  @override
  Future<WritingQuestModel> getWritingQuest(int level) async {
    try {
      final docId = 'writing_$level';
      var doc = await firestore.collection('writing_quests').doc(docId).get();

      if (!doc.exists) {
        final fallbackId = 'writing_${((level - 1) % 5) + 1}';
        doc = await firestore
            .collection('writing_quests')
            .doc(fallbackId)
            .get();
      }

      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = docId;
        data['difficulty'] = level;
        return WritingQuestModel.fromJson(data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
