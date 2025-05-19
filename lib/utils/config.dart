import 'package:intl/intl.dart';

class AppConfig {
  static const String cityEndpoint = '/City';
  static const String menuEndpoint = '/Menu';

  // Use API mealType values directly
  static const List<String> mealTypes = [
    'Kahvaltı',
    'Akşam Yemeği',
  ];

  static const String allMealTypesLabel = 'Tüm Öğünler';

  static final DateFormat apiDateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat displayDateFormat = DateFormat('dd.MM.yyyy');
}