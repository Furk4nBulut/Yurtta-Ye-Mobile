# yurttaye

KYK Yurt Yemek Takibi Mobil Uygulaması

YurttaYe-Mobile/
├── lib/
│   ├── models/
│   │   ├── city.dart                 // Şehir: id, name
│   │   ├── menu.dart                 // Menü: id, cityId, mealType, date, energy, items
│   │   ├── menu_item.dart            // Menü öğesi: id, category, name, gram
│   ├── services/
│   │   ├── api_service.dart          // API çağrıları
│   │   ├── auth_service.dart         // JWT yönetimi
│   ├── screens/
│   │   ├── splash_screen.dart        // Açılış ekranı
│   │   ├── home_screen.dart          // Menü sorgulama
│   │   ├── menu_screen.dart          // Menü detayları
│   ├── widgets/
│   │   ├── city_dropdown.dart        // Şehir dropdown
│   │   ├── meal_type_selector.dart   // Öğün seçici
│   │   ├── date_picker.dart          // Tarih seçici
│   │   ├── menu_item_card.dart       // Menü öğesi kartı
│   ├── providers/
│   │   ├── menu_provider.dart        // State yönetimi
│   ├── utils/
│   │   ├── constants.dart            // API URL, renkler
│   │   ├── helpers.dart              // Yardımcı fonksiyonlar
│   ├── routes/
│   │   ├── app_routes.dart           // Rotalar
│   ├── themes/
│   │   ├── app_theme.dart            // Tema
│   ├── main.dart                     // Giriş noktası
├── assets/
│   ├── images/
│   │   ├── logo.png                 // Logo
│   ├── fonts/
│   │   ├── Roboto-Regular.ttf       // Font (opsiyonel)
├── test/
│   ├── widget_test.dart             // Testler
├── pubspec.yaml                     // Bağımlılıklar