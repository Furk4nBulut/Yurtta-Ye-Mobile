import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class AdService {
  static String get interstitialAdUnitId {
    // Debug modda test reklamı, release modda gerçek reklam kullan
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test geçiş reklamı
    } else {
      // Release modda .env dosyasından al
      return dotenv.env['INTERSTITIAL_AD_UNIT_ID'] ?? 'ca-app-pub-9589008379442992/7379674790';
    }
  }

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  static InterstitialAd? _interstitialAd;

  static Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          print('Geçiş reklamı yüklendi');
          
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              // Yeni reklam yükle
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Geçiş reklamı gösterilemedi: $error');
              ad.dispose();
              _interstitialAd = null;
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('Geçiş reklamı yüklenemedi: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  static Future<void> showInterstitialAd() async {
    print('=== AD SERVICE DEBUG ===');
    print('Interstitial ad is null: ${_interstitialAd == null}');
    print('Ad unit ID: $interstitialAdUnitId');
    
    if (_interstitialAd != null) {
      print('Showing existing interstitial ad...');
      await _interstitialAd!.show();
    } else {
      print('Geçiş reklamı henüz yüklenmedi, yükleniyor...');
      // Reklam yüklenmemişse yeni bir tane yükle
      await loadInterstitialAd();
    }
    print('=======================');
  }

  static void dispose() {
    _interstitialAd?.dispose();
  }
} 