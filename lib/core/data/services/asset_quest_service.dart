import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:voxai_quest/core/data/constants/quest_registry.dart';

class AssetQuestService {
  final Map<String, List<Map<String, dynamic>>> _batchCache = {};
  String? _lastLoadedPath;

  /// Loads quests for a specific game and level from local assets.
  /// Returns a list of quest maps or an empty list if not found.
  Future<List<Map<String, dynamic>>> getQuests(
    String gameType,
    int level,
  ) async {
    try {
      final path = QuestRegistry.getAssetPath(gameType, level);

      // Return from cache if already loaded
      if (_lastLoadedPath == path && _batchCache.containsKey(path)) {
        return _batchCache[path]!;
      }

      // Load new batch
      final String jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> data = jsonDecode(jsonString);

      if (data.containsKey('quests') && data['quests'] is List) {
        final quests = List<Map<String, dynamic>>.from(data['quests']);

        // Update cache
        _batchCache.clear(); // Keep only one batch in memory to save RAM
        _batchCache[path] = quests;
        _lastLoadedPath = path;

        // Filter quests for the specific level
        // Each level is expected to have 3 questions
        return quests.where((q) {
          final id = q['id'] as String? ?? '';
          // Expected ID format: {type}_L{Level}_...
          // e.g., raa_L001_01
          return id.contains('_L${level.toString().padLeft(3, '0')}_');
        }).toList();
      }

      return [];
    } catch (e) {
      // Asset might not exist or parsing failed
      return [];
    }
  }

  /// Clears the memory cache.
  void clearCache() {
    _batchCache.clear();
    _lastLoadedPath = null;
  }
}
