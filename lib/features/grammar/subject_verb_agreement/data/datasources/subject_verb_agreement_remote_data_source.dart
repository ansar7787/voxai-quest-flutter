import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/grammar/subject_verb_agreement/data/models/subject_verb_agreement_quest_model.dart';

abstract class SubjectVerbAgreementRemoteDataSource {
  Future<List<SubjectVerbAgreementQuestModel>> getSubjectVerbAgreementQuests(
    int level,
  );
}

class SubjectVerbAgreementRemoteDataSourceImpl
    implements SubjectVerbAgreementRemoteDataSource {
  final FirebaseFirestore firestore;

  SubjectVerbAgreementRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<SubjectVerbAgreementQuestModel>> getSubjectVerbAgreementQuests(
    int level,
  ) async {
    final doc = await firestore
        .collection('quests')
        .doc('subjectVerbAgreement')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return SubjectVerbAgreementQuestModel.fromJson(questMap);
        }).toList();
      }
      return [SubjectVerbAgreementQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for subjectVerbAgreement');
    }
  }
}
