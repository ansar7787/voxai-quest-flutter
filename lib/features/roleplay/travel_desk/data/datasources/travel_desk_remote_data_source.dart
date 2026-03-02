import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/roleplay/travel_desk/data/models/travel_desk_quest_model.dart';

abstract class TravelDeskRemoteDataSource {
  Future<List<TravelDeskQuestModel>> getTravelDeskQuests(int level);
}

class TravelDeskRemoteDataSourceImpl implements TravelDeskRemoteDataSource {
  final FirebaseFirestore firestore;

  TravelDeskRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<TravelDeskQuestModel>> getTravelDeskQuests(int level) async {
    final snapshot = await firestore
        .collection('curriculum')
        .doc('roleplay')
        .collection('travelDesk')
        .where('difficulty', isEqualTo: level)
        .get();

    return snapshot.docs
        .map((doc) => TravelDeskQuestModel.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }
}
