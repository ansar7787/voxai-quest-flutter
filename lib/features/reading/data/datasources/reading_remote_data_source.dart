import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/features/reading/data/models/reading_quest_model.dart';

abstract class ReadingRemoteDataSource {
  Future<ReadingQuestModel> getReadingQuest(int level);
}

class ReadingRemoteDataSourceImpl implements ReadingRemoteDataSource {
  final FirebaseFirestore firestore;

  ReadingRemoteDataSourceImpl(this.firestore);

  @override
  Future<ReadingQuestModel> getReadingQuest(int level) async {
    try {
      final docId = 'reading_$level';
      var doc = await firestore.collection('reading_quests').doc(docId).get();

      if (!doc.exists) {
        // Fallback: Fetch a random quest from the collection to ensure "unlimited" feel
        final snapshot = await firestore.collection('reading_quests').get();
        if (snapshot.docs.isNotEmpty) {
          final randomIndex =
              (level - 1) % snapshot.docs.length; // Deterministic random
          doc = snapshot.docs[randomIndex];
        }
      }

      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        data['difficulty'] = level;
        return ReadingQuestModel.fromJson(data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
