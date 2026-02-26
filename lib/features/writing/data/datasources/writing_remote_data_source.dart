import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/features/writing/data/models/writing_quest_model.dart';

abstract class WritingRemoteDataSource {
  Future<List<WritingQuestModel>> getWritingQuest({
    required GameSubtype gameType,
    required int level,
  });
}

class WritingRemoteDataSourceImpl implements WritingRemoteDataSource {
  final FirebaseFirestore firestore;

  WritingRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<WritingQuestModel>> getWritingQuest({
    required GameSubtype gameType,
    required int level,
  }) async {
    try {
      // New structure: quests/{gameType}/levels/{level}
      var doc = await firestore
          .collection('quests')
          .doc(gameType.name)
          .collection('levels')
          .doc(level.toString())
          .get();

      // Fallback to old structure for backward compatibility
      if (!doc.exists) {
        final docId = 'writing_$level';
        doc = await firestore.collection('writing_quests').doc(docId).get();
      }

      // Final fallback: get any quest from the collection
      if (!doc.exists) {
        final snapshot = await firestore
            .collection('quests')
            .doc(gameType.name)
            .collection('levels')
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          doc = snapshot.docs.first;
        }
      }

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;

        // Multi-question support
        if (data.containsKey('quests') && data['quests'] is List) {
          final questsList = data['quests'] as List;
          return questsList.map((q) {
            final questMap = q as Map<String, dynamic>;
            questMap['id'] ??= doc.id;
            questMap['subtype'] = gameType.name;
            // Ensure difficulty fits if missing?
            questMap['difficulty'] ??= level;
            return WritingQuestModel.fromJson(
              questMap,
              questMap['id'] ?? doc.id,
            );
          }).toList();
        }

        // Single quest fallback
        data['id'] = doc.id;
        data['difficulty'] = level;
        data['subtype'] = gameType.name;
        return [WritingQuestModel.fromJson(data, data['id'] ?? doc.id)];
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
