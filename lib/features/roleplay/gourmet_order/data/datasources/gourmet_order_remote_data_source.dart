import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/roleplay/gourmet_order/data/models/gourmet_order_quest_model.dart';

abstract class GourmetOrderRemoteDataSource {
  Future<List<GourmetOrderQuestModel>> getGourmetOrderQuests(int level);
}

class GourmetOrderRemoteDataSourceImpl implements GourmetOrderRemoteDataSource {
  final FirebaseFirestore firestore;

  GourmetOrderRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<GourmetOrderQuestModel>> getGourmetOrderQuests(int level) async {
    final snapshot = await firestore
        .collection('curriculum')
        .doc('roleplay')
        .collection('gourmetOrder')
        .where('difficulty', isEqualTo: level)
        .get();

    return snapshot.docs
        .map(
          (doc) => GourmetOrderQuestModel.fromJson(doc.data()..['id'] = doc.id),
        )
        .toList();
  }
}
