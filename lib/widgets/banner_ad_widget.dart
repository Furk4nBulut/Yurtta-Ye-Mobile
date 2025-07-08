import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:yurttaye_mobile/utils/constants.dart';
import 'package:yurttaye_mobile/utils/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _adFreeActive = false;
  bool _bannerBlocked = false;

  @override
  void initState() {
    super.initState();
    _checkAdFreeAndLoad();
  }

  Future<void> _checkAdFreeAndLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final adFreeMillis = prefs.getInt('adFreeUntil');
    final adFreeActive = adFreeMillis != null && DateTime.now().isBefore(DateTime.fromMillisecondsSinceEpoch(adFreeMillis));
    final bannerMillis = prefs.getInt('bannerAdBlockUntil');
    final bannerBlocked = bannerMillis != null && DateTime.now().isBefore(DateTime.fromMillisecondsSinceEpoch(bannerMillis));
    setState(() {
      _adFreeActive = adFreeActive;
      _bannerBlocked = bannerBlocked;
    });
    if (!adFreeActive && !bannerBlocked) {
      _loadBannerAd();
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AppConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner ad loaded successfully.');
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_adFreeActive || _bannerBlocked || !_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }
    return Container(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      margin: const EdgeInsets.symmetric(vertical: Constants.space2),
      child: AdWidget(ad: _bannerAd!),
    );
  }
} 