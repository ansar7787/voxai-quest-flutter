import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logAdImpression(String adType) async {
    await _analytics.logEvent(
      name: 'ad_impression',
      parameters: {'ad_type': adType},
    );
  }

  Future<void> logLevelComplete(String gameType, int level) async {
    await _analytics.logEvent(
      name: 'level_complete',
      parameters: {'game_type': gameType, 'level': level},
    );
  }

  Future<void> logLevelFail(String gameType, int level) async {
    await _analytics.logEvent(
      name: 'level_fail',
      parameters: {'game_type': gameType, 'level': level},
    );
  }

  Future<void> logRescueLifeUsed(String gameType, int level) async {
    await _analytics.logEvent(
      name: 'rescue_life_used',
      parameters: {'game_type': gameType, 'level': level},
    );
  }

  Future<void> logDailySpinUsed() async {
    await _analytics.logEvent(name: 'daily_spin_used');
  }

  Future<void> logDailySpinAdWatched() async {
    await _analytics.logEvent(name: 'daily_spin_ad_watched');
  }
}
