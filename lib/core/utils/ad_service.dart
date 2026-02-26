import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdService {
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  DateTime? _lastInterstitialTime;
  static const int interstitialCooldownMinutes = 3;
  static const int maxFailedLoadAttempts = 3;

  static final AdRequest request = AdRequest(
    keywords: const <String>['game', 'learning', 'education'],
    contentUrl: 'https://voxai-quest.com',
    nonPersonalizedAds: true,
  );

  Future<void> init() async {
    if (!kIsWeb) {
      await MobileAds.instance.initialize();
    }
  }

  void loadInterstitialAd() {
    final adUnitId = Platform.isAndroid
        ? dotenv.env['ADMOB_INTERSTITIAL_ANDROID'] ?? ''
        : dotenv.env['ADMOB_INTERSTITIAL_IOS'] ?? '';

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            loadInterstitialAd();
          }
        },
      ),
    );
  }

  void showInterstitialAd({
    required VoidCallback onDismissed,
    required bool isPremium,
  }) {
    // Check if premium or ad not loaded
    if (isPremium || _interstitialAd == null) {
      onDismissed();
      return;
    }

    // Pacing Logic: Don't show if cooldown hasn't passed
    final now = DateTime.now();
    if (_lastInterstitialTime != null) {
      final difference = now.difference(_lastInterstitialTime!);
      if (difference.inMinutes < interstitialCooldownMinutes) {
        debugPrint(
          'AdService: Interstitial skipped due to pacing ($interstitialCooldownMinutes min cooldown)',
        );
        onDismissed();
        return;
      }
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        _lastInterstitialTime = DateTime.now();
        ad.dispose();
        loadInterstitialAd();
        onDismissed();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        loadInterstitialAd();
        onDismissed();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  Future<bool> shouldShowFirstTimeAd(String gameCategory, int level) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'ad_shown_${gameCategory}_$level';

    // If we've already shown it for this level, don't show it again
    if (prefs.getBool(key) == true) {
      return false;
    }

    // Otherwise, mark it as shown and return true to show the ad
    await prefs.setBool(key, true);
    return true;
  }

  // Rewarded Ads
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  void loadRewardedAd() {
    final adUnitId = Platform.isAndroid
        ? dotenv.env['ADMOB_REWARDED_ANDROID'] ??
              'ca-app-pub-3940256099942544/5224354917'
        : dotenv.env['ADMOB_REWARDED_IOS'] ??
              'ca-app-pub-3940256099942544/1712485313';

    RewardedAd.load(
      adUnitId: adUnitId,
      request: request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numRewardedLoadAttempts += 1;
          _rewardedAd = null;
          if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
            loadRewardedAd();
          }
        },
      ),
    );
  }

  void showRewardedAd({
    required Function(RewardItem) onUserEarnedReward,
    required VoidCallback onDismissed,
  }) {
    if (_rewardedAd == null) {
      debugPrint('Warning: Attempted to show rewarded ad before loaded.');
      onDismissed();
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        loadRewardedAd();
        onDismissed();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        loadRewardedAd();
        onDismissed();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        onUserEarnedReward(reward);
      },
    );
    _rewardedAd = null;
  }
}
