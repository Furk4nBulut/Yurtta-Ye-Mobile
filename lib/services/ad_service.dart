import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:yurttaye_mobile/utils/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdService {
  static String get interstitialAdUnitId {
    return AppConfig.interstitialAdUnitId;
  }

  static String get rewardedAdUnitId => AppConfig.rewardedAdUnitId;

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;

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

  static Future<bool> isAdFreeActive() async {
    final prefs = await SharedPreferences.getInstance();
    final adFreeMillis = prefs.getInt('adFreeUntil');
    if (adFreeMillis == null) return false;
    return DateTime.now().isBefore(DateTime.fromMillisecondsSinceEpoch(adFreeMillis));
  }

  static Future<bool> isInterstitialBlocked() async {
    final prefs = await SharedPreferences.getInstance();
    final blockMillis = prefs.getInt('interstitialAdBlockUntil');
    if (blockMillis == null) return false;
    return DateTime.now().isBefore(DateTime.fromMillisecondsSinceEpoch(blockMillis));
  }

  static Future<void> showInterstitialAd() async {
    if (await isAdFreeActive()) {
      print('Ad-free active, interstitial ad not shown.');
      return;
    }
    if (await isInterstitialBlocked()) {
      print('Interstitial ad block active, not showing interstitial ad.');
      return;
    }
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

  static Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          print('Rewarded reklam yüklendi');
        },
        onAdFailedToLoad: (error) {
          print('Rewarded reklam yüklenemedi: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  static Future<void> showRewardedAd({required VoidCallback onRewarded, VoidCallback? onClosed}) async {
    if (_rewardedAd == null) {
      print('Rewarded reklam henüz yüklenmedi, yükleniyor...');
      await loadRewardedAd();
    }
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedAd = null;
          loadRewardedAd();
          if (onClosed != null) onClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Rewarded reklam gösterilemedi: $error');
          ad.dispose();
          _rewardedAd = null;
          if (onClosed != null) onClosed();
        },
      );
      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          print('Kullanıcı ödül kazandı: ${reward.amount} ${reward.type}');
          onRewarded();
        },
      );
    } else {
      print('Rewarded reklam yüklenemedi.');
      if (onClosed != null) onClosed();
    }
  }
} 