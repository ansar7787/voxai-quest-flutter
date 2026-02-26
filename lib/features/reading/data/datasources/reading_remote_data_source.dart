import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/features/reading/data/models/reading_quest_model.dart';

abstract class ReadingRemoteDataSource {
  Future<List<ReadingQuestModel>> getReadingQuest({
    required GameSubtype gameType,
    required int level,
  });
}

class ReadingRemoteDataSourceImpl implements ReadingRemoteDataSource {
  final FirebaseFirestore firestore;

  ReadingRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<ReadingQuestModel>> getReadingQuest({
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
        final docId = 'reading_$level';
        doc = await firestore.collection('reading_quests').doc(docId).get();
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

        // Check if new structure with 'quests' array exists
        if (data.containsKey('quests') && data['quests'] is List) {
          final questsList = data['quests'] as List;
          return questsList.map((q) {
            final questMap = q as Map<String, dynamic>;
            // Ensure ID and other fields are consistent if needed,
            // though they should be in the map from generation
            questMap['id'] ??= doc.id;
            return ReadingQuestModel.fromJson(
              questMap,
              questMap['id'] ?? doc.id,
            );
          }).toList();
        }

        // Fallback for old single-quest structure
        data['id'] = doc.id;
        data['difficulty'] = level;
        data['subtype'] = gameType.name;
        return [ReadingQuestModel.fromJson(data, data['id'] ?? doc.id)];
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
