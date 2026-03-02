import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/roleplay/job_interview/data/models/job_interview_quest_model.dart';

abstract class JobInterviewRemoteDataSource {
  Future<List<JobInterviewQuestModel>> getJobInterviewQuests(int level);
}

class JobInterviewRemoteDataSourceImpl implements JobInterviewRemoteDataSource {
  final FirebaseFirestore firestore;

  JobInterviewRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<JobInterviewQuestModel>> getJobInterviewQuests(int level) async {
    final snapshot = await firestore
        .collection('curriculum')
        .doc('roleplay')
        .collection('jobInterview')
        .where('difficulty', isEqualTo: level)
        .get();

    return snapshot.docs
        .map((doc) => JobInterviewQuestModel.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }
}
