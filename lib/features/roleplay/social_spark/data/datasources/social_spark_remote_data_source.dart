import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/roleplay/social_spark/data/models/social_spark_quest_model.dart';

abstract class SocialSparkRemoteDataSource {
  Future<List<SocialSparkQuestModel>> getSocialSparkQuests(int level);
}

class SocialSparkRemoteDataSourceImpl implements SocialSparkRemoteDataSource {
  final FirebaseFirestore firestore;

  SocialSparkRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SocialSparkQuestModel>> getSocialSparkQuests(int level) async {
    final snapshot = await firestore
        .collection('curriculum')
        .doc('roleplay')
        .collection('socialSpark')
        .where('difficulty', isEqualTo: level)
        .get();

    return snapshot.docs
        .map(
          (doc) => SocialSparkQuestModel.fromJson(doc.data()..['id'] = doc.id),
        )
        .toList();
  }
}
