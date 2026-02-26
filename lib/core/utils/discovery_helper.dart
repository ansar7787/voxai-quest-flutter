import 'dart:math';
import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';

class DiscoveryHelper {
  static List<GameQuest> getQuestsForSequence(
    String sequenceId,
    UserEntity user,
  ) {
    switch (sequenceId) {
      case 'daily_duo':
        return _generateDailyDuo(user);
      case 'speed_blitz':
        return _generateSpeedBlitz(user);
      case 'grammar_pro':
        return _generateGrammarPro(user);
      case 'smart_recommendation':
        return _generateSmartRecommendation(user);
      default:
        return _generateRandomQuest(user);
    }
  }

  static List<GameQuest> _generateSmartRecommendation(UserEntity user) {
    // Pick the category with the lowest progress
    QuestType lowestType = QuestType.speaking;
    int lowestProgress = 100;

    for (final type in QuestType.values) {
      final progress = user.getCategoryProgress(type);
      if (progress < lowestProgress) {
        lowestProgress = progress;
        lowestType = type;
      }
    }

    return [_getRandomGameForCategory(user, lowestType)];
  }

  static List<GameQuest> _generateDailyDuo(UserEntity user) {
    // Mixed vocal & reading
    final speakingGame = _getRandomGameForCategory(user, QuestType.speaking);
    final readingGame = _getRandomGameForCategory(user, QuestType.reading);

    return [
      speakingGame.copyWith(
        instruction: 'Warm up your voice with this speaking drill.',
      ),
      readingGame.copyWith(
        instruction: 'Switch gears and focus on reading comprehension.',
      ),
    ];
  }

  static List<GameQuest> _generateSpeedBlitz(UserEntity user) {
    // Fast challenges: reading speed + sentence order
    return [
      _getQuestForSubtype(
        user,
        GameSubtype.readingSpeedCheck,
        'Read as fast as you can!',
      ),
      _getQuestForSubtype(
        user,
        GameSubtype.sentenceOrderReading,
        'Put the sentences in order fast.',
      ),
    ];
  }

  static List<GameQuest> _generateGrammarPro(UserEntity user) {
    // Elite structural drill
    return [
      _getQuestForSubtype(
        user,
        GameSubtype.grammarQuest,
        'Analyze and solve the grammar puzzle.',
      ),
      _getQuestForSubtype(
        user,
        GameSubtype.sentenceCorrection,
        'Identify and fix any structural errors.',
      ),
    ];
  }

  static List<GameQuest> _generateRandomQuest(UserEntity user) {
    final types = QuestType.values;
    final randomType = types[Random().nextInt(types.length)];
    return [_getRandomGameForCategory(user, randomType)];
  }

  static GameQuest _getRandomGameForCategory(UserEntity user, QuestType type) {
    final subtypes = type.subtypes;
    final subtype = subtypes[Random().nextInt(subtypes.length)];
    return _getQuestForSubtype(
      user,
      subtype,
      'Enhance your ${type.name} skills with this quest!',
    );
  }

  static GameQuest _getQuestForSubtype(
    UserEntity user,
    GameSubtype subtype,
    String instruction,
  ) {
    final currentLevel = user.unlockedLevels[subtype.name] ?? 1;
    return GameQuest(
      id: '${subtype.name}_$currentLevel',
      type: subtype.category,
      subtype: subtype,
      instruction: instruction,
      difficulty: currentLevel,
    );
  }
}

extension GameQuestX on GameQuest {
  GameQuest copyWith({
    String? id,
    QuestType? type,
    GameSubtype? subtype,
    String? instruction,
    int? difficulty,
  }) {
    return GameQuest(
      id: id ?? this.id,
      type: type ?? this.type,
      subtype: subtype ?? this.subtype,
      instruction: instruction ?? this.instruction,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
