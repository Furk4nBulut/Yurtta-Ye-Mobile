# YurttaYe Mobile App - Lib Klasörü Yapısı

Bu klasör, YurttaYe mobil uygulamasının ana kod yapısını içerir. Kod, modüler ve sürdürülebilir bir yapıda organize edilmiştir.

## Klasör Yapısı

### 📁 models/
Uygulama veri modellerini içerir:
- `city.dart` - Şehir modeli
- `menu.dart` - Menü modeli
- `menu_item.dart` - Menü öğesi modeli

### 📁 providers/
State management için Provider sınıflarını içerir:
- `menu_provider.dart` - Menü verilerinin yönetimi
- `theme_provider.dart` - Tema değişikliklerinin yönetimi

### 📁 screens/
Ana ekran widget'larını içerir:
- `home_screen.dart` - Ana sayfa (refactor edilmiş)
- `filter_screen.dart` - Filtre sayfası
- `menu_detail_screen.dart` - Menü detay sayfası
- `splash_screen.dart` - Açılış ekranı

### 📁 widgets/
Yeniden kullanılabilir UI bileşenlerini içerir:
- `bottom_navigation_bar.dart` - Özel alt navigasyon çubuğu
- `category_section.dart` - Kategori bölümü
- `date_selector.dart` - Tarih seçici
- `empty_state_widget.dart` - Boş durum widget'ı
- `error_widget.dart` - Hata widget'ı
- `meal_card.dart` - Yemek kartı
- `shimmer_loading.dart` - Yükleme animasyonu
- `upcoming_meal_card.dart` - Yaklaşan yemek kartı
- `upcoming_meals_section.dart` - Yaklaşan yemekler bölümü

### 📁 services/
API ve diğer servisleri içerir:
- `api_service.dart` - API çağrıları

### 📁 themes/
Uygulama teması ayarlarını içerir:
- `app_theme.dart` - Ana tema konfigürasyonu

### 📁 utils/
Yardımcı sınıflar ve sabitler:
- `config.dart` - Uygulama konfigürasyonu
- `constants.dart` - Sabit değerler

### 📁 routes/
Uygulama rotalarını içerir:
- `app_routes.dart` - Rota tanımlamaları

## Refactor Edilen Yapı

### HomeScreen Refactoring
Ana sayfa aşağıdaki widget'lara bölünmüştür:

1. **DateSelector** - Tarih seçimi ve navigasyonu
2. **EmptyStateWidget** - Veri olmadığında gösterilen mesaj
3. **CustomBottomNavigationBar** - Alt navigasyon çubuğu
4. **UpcomingMealsSection** - Yaklaşan yemekler bölümü

### Avantajlar
- **Modülerlik**: Her widget kendi sorumluluğuna sahip
- **Yeniden Kullanılabilirlik**: Widget'lar başka yerlerde de kullanılabilir
- **Test Edilebilirlik**: Küçük parçalar daha kolay test edilir
- **Bakım Kolaylığı**: Kod daha organize ve anlaşılır
- **Performans**: Gereksiz rebuild'ler önlenir

### Kullanım Örnekleri

```dart
// Tarih seçici kullanımı
DateSelector(
  selectedDate: selectedDate,
  onDateChanged: (isNext) => changeDate(isNext),
  hasPreviousMenu: hasPrevious,
  hasNextMenu: hasNext,
  opacity: opacity,
)

// Boş durum widget'ı
EmptyStateWidget(
  selectedDate: selectedDate,
  onEmailPressed: () => launchEmail(),
)

// Alt navigasyon çubuğu
CustomBottomNavigationBar(
  selectedMealIndex: selectedIndex,
  onMealTypeChanged: (index) => changeMealType(index),
  pulseController: pulseController,
  pulseAnimation: pulseAnimation,
)
```

## Geliştirme Kuralları

1. **Single Responsibility**: Her widget tek bir sorumluluğa sahip olmalı
2. **Dependency Injection**: Gerekli parametreler constructor'dan geçirilmeli
3. **Immutable Widgets**: Mümkün olduğunca stateless widget'lar kullanılmalı
4. **Consistent Naming**: Widget isimleri açıklayıcı olmalı
5. **Documentation**: Karmaşık widget'lar için dokümantasyon eklenmeli 