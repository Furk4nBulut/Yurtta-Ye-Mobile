import 'package:intl/intl.dart';

class AppConfig {
  // App Information
  static const String appName = 'YurttaYe';
  static const String appVersion = '1.1.0';
  static const String appBuildNumber = '9';
  
  // Website URLs
  static const String websiteUrl = 'https://yurttaye.onrender.com/';
  static const String githubUrl = 'https://github.com/bulutsoft-dev/Yurtta-Ye-Mobile';
  
  // Developer Information
  static const String developerName = 'Furkan Bulut';
  static const String developerEmail = 'bulutsoftdev@gmail.com';
  static const String developerCompany = 'BulutSoft Dev';
  
  // App Store Links
  static const String googlePlayUrl = 'https://play.google.com/store/apps/details?id=com.yurttaye.yurttaye';
  
  // Support Information
  static const String supportEmail = 'bulutsoftdev@gmail.com';
  static const String privacyPolicyUrl = 'https://github.com/bulutsoft-dev/Yurtta-Ye-Mobile/blob/main/privacy-policy.md';
  
  // API Configuration
  static const String apiBaseUrl = 'https://yurttaye.onrender.com/api';
  static const String cityEndpoint = '/City';
  static const String menuEndpoint = '/Menu';

  // Localization
  static const String defaultLanguage = 'tr';
  static const List<String> supportedLanguages = ['tr', 'en'];
  
  // Öğün türleri
  static const List<String> mealTypes = [
    'Kahvaltı',
    'Akşam Yemeği',
  ];
  static const String allMealTypesLabel = 'Tüm Öğünler';

  // Tarih formatları
  static final DateFormat apiDateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat displayDateFormat = DateFormat('dd.MM.yyyy');

  // Sayfalama ayarları
  static const int pageSize = 5; // Sayfa başına menü
  static const int initialPage = 1;
} 