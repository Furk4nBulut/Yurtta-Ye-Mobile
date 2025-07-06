class Localization {
  static const Map<String, Map<String, String>> _translations = {
    'tr': {
      // App Bar
      'app_title': 'YurttaYe',
      'settings': 'Ayarlar',
      'filter': 'Filtrele',
      'website': 'Web Sitesi',
      'language': 'Dil',
      
      // Settings Screen
      'app_settings': 'Uygulama Ayarları',
      'theme': 'Tema',
      'dark_theme': 'Koyu Tema',
      'light_theme': 'Açık Tema',
      'notifications': 'Bildirimler',
      'meal_reminders': 'Yemek hatırlatıcıları',
      'select_language': 'Dil Seçin',
      
      // Links Section
      'links': 'Bağlantılar',
      'website_subtitle': 'yurttaye.onrender.com',
      'github': 'GitHub',
      'source_code': 'Kaynak kod',
      'google_play': 'Google Play',
      'rate_app': 'Uygulamayı değerlendir',
      
      // About Section
      'about': 'Hakkında',
      'app_version': 'Uygulama Versiyonu',
      'privacy_policy': 'Gizlilik Politikası',
      'terms_of_use': 'Kullanım şartları',
      'report_bug': 'Hata Bildir',
      'report_issue': 'Sorun bildir',
      
      // Developer Section
      'developer': 'Geliştirici',
      'developer_name': 'Furkan Bulut',
      'company': 'Firma',
      'contact': 'İletişim',
      
      // Dialogs
      'app_info': 'Uygulama Bilgileri',
      'developer_info': 'Geliştirici Bilgileri',
      'name': 'Ad',
      'email': 'E-posta',
      'version': 'Versiyon',
      'build': 'Build',
      'platform': 'Platform',
      'license': 'Lisans',
      'ok': 'Tamam',
      'cancel': 'İptal',
      'understood': 'Anladım',
      
      // Home Screen
      'upcoming_meals': 'Gelecek Menüleri',
      'no_upcoming_meals': 'Gelecek menü bulunamadı',
      'website_visit': 'Website\'yi Ziyaret Et',
      'change_language': 'Dili Değiştir',
      'light_theme_tooltip': 'Açık Tema',
      'dark_theme_tooltip': 'Koyu Tema',
      
      // Meal Types
      'breakfast': 'Kahvaltı',
      'lunch': 'Öğle Yemeği',
      'dinner': 'Akşam Yemeği',
      
      // Common
      'loading': 'Yükleniyor...',
      'error': 'Hata',
      'retry': 'Tekrar Dene',
      'refresh': 'Yenile',
      'no_data': 'Veri bulunamadı',
    },
    'en': {
      // App Bar
      'app_title': 'YurttaYe',
      'settings': 'Settings',
      'filter': 'Filter',
      'website': 'Website',
      'language': 'Language',
      
      // Settings Screen
      'app_settings': 'App Settings',
      'theme': 'Theme',
      'dark_theme': 'Dark Theme',
      'light_theme': 'Light Theme',
      'notifications': 'Notifications',
      'meal_reminders': 'Meal reminders',
      'select_language': 'Select Language',
      
      // Links Section
      'links': 'Links',
      'website_subtitle': 'yurttaye.onrender.com',
      'github': 'GitHub',
      'source_code': 'Source code',
      'google_play': 'Google Play',
      'rate_app': 'Rate the app',
      
      // About Section
      'about': 'About',
      'app_version': 'App Version',
      'privacy_policy': 'Privacy Policy',
      'terms_of_use': 'Terms of use',
      'report_bug': 'Report Bug',
      'report_issue': 'Report issue',
      
      // Developer Section
      'developer': 'Developer',
      'developer_name': 'Furkan Bulut',
      'company': 'Company',
      'contact': 'Contact',
      
      // Dialogs
      'app_info': 'App Information',
      'developer_info': 'Developer Information',
      'name': 'Name',
      'email': 'Email',
      'version': 'Version',
      'build': 'Build',
      'platform': 'Platform',
      'license': 'License',
      'ok': 'OK',
      'cancel': 'Cancel',
      'understood': 'Understood',
      
      // Home Screen
      'upcoming_meals': 'Upcoming Meals',
      'no_upcoming_meals': 'No upcoming meals found',
      'website_visit': 'Visit Website',
      'change_language': 'Change Language',
      'light_theme_tooltip': 'Light Theme',
      'dark_theme_tooltip': 'Dark Theme',
      
      // Meal Types
      'breakfast': 'Breakfast',
      'lunch': 'Lunch',
      'dinner': 'Dinner',
      
      // Common
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'refresh': 'Refresh',
      'no_data': 'No data found',
    },
  };

  static String getText(String key, String languageCode) {
    return _translations[languageCode]?[key] ?? _translations['tr']![key] ?? key;
  }

  static String getCurrentText(String key, String currentLanguageCode) {
    return getText(key, currentLanguageCode);
  }
} 