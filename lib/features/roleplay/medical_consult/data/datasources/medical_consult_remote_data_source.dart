import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/roleplay/medical_consult/data/models/medical_consult_quest_model.dart';

abstract class MedicalConsultRemoteDataSource {
  Future<List<MedicalConsultQuestModel>> getMedicalConsultQuests(int level);
}

class MedicalConsultRemoteDataSourceImpl implements MedicalConsultRemoteDataSource {
  final FirebaseFirestore firestore;

  MedicalConsultRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<MedicalConsultQuestModel>> getMedicalConsultQuests(int level) async {
    final snapshot = await firestore
        .collection('curriculum')
        .doc('roleplay')
        .collection('medicalConsult')
        .where('difficulty', isEqualTo: level)
        .get();

    return snapshot.docs
        .map((doc) => MedicalConsultQuestModel.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }
}
