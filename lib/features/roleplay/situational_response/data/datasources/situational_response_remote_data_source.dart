import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/roleplay/situational_response/data/models/situational_response_quest_model.dart';

abstract class SituationalResponseRemoteDataSource {
  Future<List<SituationalResponseQuestModel>> getSituationalResponseQuests(int level);
}

class SituationalResponseRemoteDataSourceImpl implements SituationalResponseRemoteDataSource {
  final FirebaseFirestore firestore;

  SituationalResponseRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SituationalResponseQuestModel>> getSituationalResponseQuests(int level) async {
    final snapshot = await firestore
        .collection('curriculum')
        .doc('roleplay')
        .collection('situationalResponse')
        .where('difficulty', isEqualTo: level)
        .get();

    return snapshot.docs
        .map((doc) => SituationalResponseQuestModel.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }
}
