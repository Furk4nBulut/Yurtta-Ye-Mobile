import 'package:shared_preferences/shared_preferences.dart';
import 'package:yurttaye_mobile/services/ad_service.dart';

class AdManager {
  static const String _lastAdShownKey = 'last_ad_shown';
  static const String _adShownCountKey = 'ad_shown_count';
  static const int _minAdIntervalMinutes = 0; // Test için 0 dakika aralık
  static const int _maxAdsPerSession = 10; // Test için 10 reklam

  static Future<bool> shouldShowAd() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Son reklam gösterilme zamanını kontrol et
      final lastAdShown = prefs.getInt(_lastAdShownKey) ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final timeSinceLastAd = (currentTime - lastAdShown) / (1000 * 60); // Dakika cinsinden
      
      // Bugün gösterilen reklam sayısını kontrol et
      final today = DateTime.now().day;
      final adShownCount = prefs.getInt('${_adShownCountKey}_$today') ?? 0;
      
      // Reklam gösterilme koşulları
      final canShowByTime = timeSinceLastAd >= _minAdIntervalMinutes;
      final canShowByCount = adShownCount < _maxAdsPerSession;
      
      // Debug logları
      print('=== AD MANAGER DEBUG ===');
      print('Last ad shown: $lastAdShown');
      print('Current time: $currentTime');
      print('Time since last ad: ${timeSinceLastAd.toStringAsFixed(2)} minutes');
      print('Today: $today');
      print('Ad shown count today: $adShownCount');
      print('Can show by time: $canShowByTime');
      print('Can show by count: $canShowByCount');
      print('Min interval: $_minAdIntervalMinutes minutes');
      print('Max ads per session: $_maxAdsPerSession');
      print('Final result: ${canShowByTime && canShowByCount}');
      print('=======================');
      
      return canShowByTime && canShowByCount;
    } catch (e) {
      print('AdManager shouldShowAd error: $e');
      return false;
    }
  }

  static Future<void> recordAdShown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Son reklam gösterilme zamanını kaydet
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt(_lastAdShownKey, currentTime);
      
      // Bugün gösterilen reklam sayısını artır
      final today = DateTime.now().day;
      final currentCount = prefs.getInt('${_adShownCountKey}_$today') ?? 0;
      await prefs.setInt('${_adShownCountKey}_$today', currentCount + 1);
      
      print('Ad shown recorded. Count today: ${currentCount + 1}');
    } catch (e) {
      print('AdManager recordAdShown error: $e');
    }
  }

  static Future<void> showAdIfAllowed() async {
    if (await shouldShowAd()) {
      await AdService.showInterstitialAd();
      await recordAdShown();
    } else {
      print('Ad not shown - conditions not met');
    }
  }

  static Future<void> resetDailyCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().day;
      await prefs.remove('${_adShownCountKey}_$today');
      print('Daily ad count reset');
    } catch (e) {
      print('AdManager resetDailyCount error: $e');
    }
  }

  static Future<Map<String, dynamic>> getAdStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final today = DateTime.now().day;
      final adShownCount = prefs.getInt('${_adShownCountKey}_$today') ?? 0;
      final lastAdShown = prefs.getInt(_lastAdShownKey) ?? 0;
      
      return {
        'todayCount': adShownCount,
        'maxPerSession': _maxAdsPerSession,
        'lastAdShown': lastAdShown,
        'minIntervalMinutes': _minAdIntervalMinutes,
      };
    } catch (e) {
      print('AdManager getAdStats error: $e');
      return {};
    }
  }
} 