YurttaYe-Mobile/
├── lib/
│   ├── models/                     # Veri modelleri
│   │   ├── city.dart             # Şehir: id, name
│   │   ├── menu.dart             # Menü: id, cityId, mealType, date, energy, items
│   │   ├── menu_item.dart        # Menü öğesi: category, name, gram
│   ├── services/                  # API çağrıları
│   │   ├── api_service.dart      # API istekleri
│   ├── screens/                   # Ekranlar
│   │   ├── home_screen.dart      # Ana ekran: Menü listesi ve filtreler
│   │   ├── menu_detail_screen.dart # Menü detay ekranı
│   ├── widgets/                   # Yeniden kullanılabilir widget’lar
│   │   ├── city_dropdown.dart    # Şehir seçimi
│   │   ├── meal_type_selector.dart # Öğün türü seçimi
│   │   ├── date_picker.dart      # Tarih seçici
│   │   ├── menu_card.dart        # Menü kartı
│   │   ├── menu_item_card.dart   # Menü öğesi kartı
│   ├── providers/                 # Durum yönetimi
│   │   ├── menu_provider.dart    # Menü ve şehir verileri
│   ├── utils/                     # Yardımcı dosyalar
│   │   ├── constants.dart        # API URL, renkler
│   ├── routes/                    # Rotalama
│   │   ├── app_routes.dart       # go_router rotaları
│   ├── themes/                    # Tema
│   │   ├── app_theme.dart        # Uygulama teması
│   ├── main.dart                  # Giriş noktası
├── assets/
│   ├── images/
│   │   ├── logo.png              # Uygulama logosu
├── test/
│   ├── widget_test.dart          # Testler
├── pubspec.yaml                  # Bağımlılıklar
├── README.md                     # Proje açıklaması