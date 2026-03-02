import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxai_quest/features/auth/presentation/bloc/auth_bloc.dart';

class BannerAdWidget extends StatefulWidget {
  final AdSize size;
  const BannerAdWidget({super.key, this.size = AdSize.banner});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    // If premium, don't even load the ad
    final authState = context.read<AuthBloc>().state;
    if (authState.user?.isPremium == true) return;

    final adUnitId = Platform.isAndroid
        ? dotenv.env['ADMOB_BANNER_ANDROID'] ??
              'ca-app-pub-3940256099942544/6300978111' // Test ID
        : dotenv.env['ADMOB_BANNER_IOS'] ??
              'ca-app-pub-3940256099942544/2934735716'; // Test ID

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: widget.size,
      request: const AdRequest(
        keywords: ['education', 'learning', 'kids', 'games'],
        nonPersonalizedAds: true,
      ),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if premium to instantly return empty
    final authState = context.watch<AuthBloc>().state;
    if (authState.user?.isPremium == true) {
      return const SizedBox.shrink();
    }

    if (_isLoaded && _bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }

    // Return empty while loading to avoid layout shifts
    return SizedBox(height: widget.size.height.toDouble());
  }
}
