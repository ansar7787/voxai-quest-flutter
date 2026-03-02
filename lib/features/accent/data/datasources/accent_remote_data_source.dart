import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/core/data/services/asset_quest_service.dart';
import '../models/accent_quest_model.dart';
import '../../../../core/domain/entities/game_quest.dart';

abstract class AccentRemoteDataSource {
  Future<List<AccentQuestModel>> getAccentQuest({
    required GameSubtype gameType,
    required int level,
  });
}

class AccentRemoteDataSourceImpl implements AccentRemoteDataSource {
  final FirebaseFirestore firestore;
  final AssetQuestService assetQuestService;

  AccentRemoteDataSourceImpl({
    required this.firestore,
    required this.assetQuestService,
  });

  @override
  Future<List<AccentQuestModel>> getAccentQuest({
    required GameSubtype gameType,
    required int level,
  }) async {
    try {
      // 1. Try to load from Local Assets (Free & Fast)
      final localData = await assetQuestService.getQuests(gameType.name, level);
      if (localData.isNotEmpty) {
        return localData.map((q) {
          final questMap = q;
          return AccentQuestModel.fromJson(questMap, questMap['id'] ?? '');
        }).toList();
      }

      // 2. Fallback to Firestore (Cloud)
      final doc = await firestore
          .collection('quests')
          .doc(gameType.name)
          .collection('levels')
          .doc(level.toString())
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data.containsKey('quests') && data['quests'] is List) {
          final questsList = data['quests'] as List;
          return questsList.map((q) {
            final questMap = Map<String, dynamic>.from(q as Map);
            questMap['subtype'] = gameType.name;
            return AccentQuestModel.fromJson(questMap, doc.id);
          }).toList();
        }
        data['subtype'] = gameType.name;
        return [AccentQuestModel.fromJson(data, doc.id)];
      } else {
        throw Exception('Level $level not found for ${gameType.name}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
