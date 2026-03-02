import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/roleplay/elevator_pitch/data/models/elevator_pitch_quest_model.dart';

abstract class ElevatorPitchRemoteDataSource {
  Future<List<ElevatorPitchQuestModel>> getElevatorPitchQuests(int level);
}

class ElevatorPitchRemoteDataSourceImpl
    implements ElevatorPitchRemoteDataSource {
  final FirebaseFirestore firestore;

  ElevatorPitchRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ElevatorPitchQuestModel>> getElevatorPitchQuests(
    int level,
  ) async {
    final snapshot = await firestore
        .collection('curriculum')
        .doc('roleplay')
        .collection('elevatorPitch')
        .where('difficulty', isEqualTo: level)
        .get();

    return snapshot.docs
        .map(
          (doc) =>
              ElevatorPitchQuestModel.fromJson(doc.data()..['id'] = doc.id),
        )
        .toList();
  }
}
