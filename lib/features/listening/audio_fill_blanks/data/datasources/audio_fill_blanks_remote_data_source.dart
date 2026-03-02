import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/listening/audio_fill_blanks/data/models/audio_fill_blanks_quest_model.dart';
import 'package:voxai_quest/core/error/exceptions.dart';

abstract class AudioFillBlanksRemoteDataSource {
  Future<List<AudioFillBlanksQuestModel>> getQuests(int level);
}

class AudioFillBlanksRemoteDataSourceImpl
    implements AudioFillBlanksRemoteDataSource {
  final FirebaseFirestore firestore;

  AudioFillBlanksRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<AudioFillBlanksQuestModel>> getQuests(int level) async {
    try {
      final doc = await firestore
          .collection('quests')
          .doc('audioFillBlanks')
          .collection('levels')
          .doc(level.toString())
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data.containsKey('quests') && data['quests'] is List) {
          final questsList = data['quests'] as List;
          return questsList.map((q) {
            final questData = Map<String, dynamic>.from(q as Map);
            questData['id'] = questData['id'] ?? doc.id;
            return AudioFillBlanksQuestModel.fromJson(questData);
          }).toList();
        }
        final finalData = doc.data()!;
        finalData['id'] = doc.id;
        return [AudioFillBlanksQuestModel.fromJson(finalData)];
      } else {
        throw ServerException(
          'Quest level $level not found for audioFillBlanks',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
