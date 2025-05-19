import 'package:intl/intl.dart';

class AppConfig {
  // API Endpoints
  static const String cityEndpoint = '/City';
  static const String menuEndpoint = '/Menu';

  // Meal Types
  static const Map<String, String> mealTypes = {
    'Kahvaltı': 'Sabah',
    'Akşam Yemeği': 'Akşam',
  };

  static const String allMealTypesLabel = 'Tüm Öğünler';

  // Date Formats
  static final DateFormat apiDateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat displayDateFormat = DateFormat('dd.MM.yyyy');

  // Error Messages
  static const String connectionError = 'Bağlantı hatası';
  static const String timeoutError = 'Bağlantı zaman aşımına uğradı';
  static const String invalidDataError = 'Geçersiz veri formatı';
  static const String cityLoadError = 'Şehirler yüklenemedi';
  static const String menuLoadError = 'Menüler yüklenemedi';
}