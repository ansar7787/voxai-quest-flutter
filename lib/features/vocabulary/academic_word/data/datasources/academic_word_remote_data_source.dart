import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/vocabulary/academic_word/data/models/academic_word_quest_model.dart';

abstract class AcademicWordRemoteDataSource {
  Future<List<AcademicWordQuestModel>> getAcademicWordQuests(int level);
}

class AcademicWordRemoteDataSourceImpl implements AcademicWordRemoteDataSource {
  final FirebaseFirestore firestore;

  AcademicWordRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<AcademicWordQuestModel>> getAcademicWordQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('academicWord')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return AcademicWordQuestModel.fromJson(questMap);
        }).toList();
      }
      return [AcademicWordQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for academicWord');
    }
  }
}
