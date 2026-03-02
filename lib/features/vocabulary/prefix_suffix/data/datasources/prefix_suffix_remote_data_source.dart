import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/vocabulary/prefix_suffix/data/models/prefix_suffix_quest_model.dart';

abstract class PrefixSuffixRemoteDataSource {
  Future<List<PrefixSuffixQuestModel>> getPrefixSuffixQuests(int level);
}

class PrefixSuffixRemoteDataSourceImpl implements PrefixSuffixRemoteDataSource {
  final FirebaseFirestore firestore;

  PrefixSuffixRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<PrefixSuffixQuestModel>> getPrefixSuffixQuests(int level) async {
    final doc = await firestore
        .collection('quests')
        .doc('prefixSuffix')
        .collection('levels')
        .doc(level.toString())
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('quests') && data['quests'] is List) {
        final questsList = data['quests'] as List;
        return questsList.map((q) {
          final questMap = Map<String, dynamic>.from(q as Map);
          return PrefixSuffixQuestModel.fromJson(questMap);
        }).toList();
      }
      return [PrefixSuffixQuestModel.fromJson(data)];
    } else {
      throw Exception('Level $level not found for prefixSuffix');
    }
  }
}
