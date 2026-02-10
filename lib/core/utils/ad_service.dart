import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdService {
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
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
    if (isPremium || _interstitialAd == null) {
      onDismissed();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
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
}
