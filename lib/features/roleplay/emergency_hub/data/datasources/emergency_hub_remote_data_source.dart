import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/roleplay/emergency_hub/data/models/emergency_hub_quest_model.dart';

abstract class EmergencyHubRemoteDataSource {
  Future<List<EmergencyHubQuestModel>> getEmergencyHubQuests(int level);
}

class EmergencyHubRemoteDataSourceImpl implements EmergencyHubRemoteDataSource {
  final FirebaseFirestore firestore;

  EmergencyHubRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<EmergencyHubQuestModel>> getEmergencyHubQuests(int level) async {
    final snapshot = await firestore
        .collection('curriculum')
        .doc('roleplay')
        .collection('emergencyHub')
        .where('difficulty', isEqualTo: level)
        .get();

    return snapshot.docs
        .map((doc) => EmergencyHubQuestModel.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }
}
