import 'package:intl/intl.dart';

class AppConfig {
  static const String cityEndpoint = '/City';
  static const String menuEndpoint = '/Menu';

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
  static const int pageSize = 2; // Sayfa başına menü
  static const int initialPage = 1;
}
