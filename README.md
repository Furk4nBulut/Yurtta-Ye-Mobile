# YurttaYe - KYK Yemek Menüsü Uygulaması

## Genel Bakış
YurttaYe, KYK yurtlarında yaşayan öğrenciler için günlük yemek menülerini takip etmeyi kolaylaştıran bir mobil uygulamadır. Uygulama, kahvaltı ve akşam yemeği menülerini şehir bazlı olarak görüntüleme imkanı sunar.

## Özellikler

### 📱 Mobil Uygulama
- **Günlük Menüler**: Kahvaltı ve akşam yemeği menülerini günlük olarak takip edin
- **Şehir Bazlı**: Bulunduğunuz şehre göre yurt menülerini görüntüleyin
- **Bildirimler**: Yemek saatlerinde otomatik bildirimler alın
- **Çoklu Dil**: Türkçe ve İngilizce dil desteği
- **Karanlık/Aydınlık Tema**: Kullanıcı tercihine göre tema seçimi
- **Reklam Entegrasyonu**: Google AdMob ile reklam desteği

### 🌐 Web Sitesi
- **Uygulama Tanıtımı**: YurttaYe uygulamasının özelliklerini tanıtan web sitesi
- **Google Play Bağlantısı**: Doğrudan uygulama indirme linki
- **AdMob Doğrulama**: app-ads.txt dosyası ile AdMob doğrulama desteği
## Kullanılan Teknolojiler

### 📱 Mobil Uygulama
- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **Reklam**: Google Mobile Ads (AdMob)
- **Bildirimler**: Flutter Local Notifications
- **API**: HTTP ile REST API entegrasyonu
- **Platformlar**: Android (iOS desteği planlanıyor)

### 🌐 Web Sitesi
- **HTML/CSS**: Modern ve responsive tasarım
- **Hosting**: Render.com
- **Domain**: yurttaye.onrender.com

## AdMob Doğrulama

Bu proje, Google AdMob reklam platformu ile entegre edilmiştir. AdMob doğrulaması için gerekli dosyalar:

### app-ads.txt İçeriği:
```
google.com, pub-9589008379442992, DIRECT, f08c47fec0942fa0
```

### Doğrulama Adımları:
1. `app-ads.txt` dosyası `yurttaye.onrender.com` web sitesinin kök dizininde yayınlanmalı
2. `https://yurttaye.onrender.com/app-ads.txt` adresinin erişilebilir olduğu kontrol edilmeli
3. AdMob hesabında uygulama doğrulaması yeniden çalıştırılmalı

## Kurulum ve Geliştirme

### Gereksinimler

**Mobil Uygulama:**
- Flutter SDK (en son kararlı sürüm)
- Android Studio veya VS Code
- Android SDK (minimum API 23)
- Google AdMob hesabı

**Web Sitesi:**
- Render.com hesabı (hosting için)
- Domain yönetimi

### Mobil Uygulama Kurulumu

1. **Repository'yi klonlayın:**
```bash
git clone https://github.com/bulutsoft-dev/Yurtta-Ye-Mobile.git
cd Yurtta-Ye-Mobile
```

2. **Bağımlılıkları yükleyin:**
```bash
flutter pub get
```

3. **AdMob yapılandırması:**
- `android/app/src/main/AndroidManifest.xml` dosyasında AdMob uygulama ID'sini kontrol edin
- `lib/services/ad_service.dart` dosyasında reklam birimi ID'lerini kontrol edin

4. **Uygulamayı çalıştırın:**
```bash
flutter run
```

### Web Sitesi Kurulumu

1. **Web dosyalarını yükleyin:**
- `web/` klasöründeki dosyaları `yurttaye.onrender.com` web sitesine yükleyin
- `app-ads.txt` dosyasının kök dizinde olduğundan emin olun

2. **Doğrulama:**
- `https://yurttaye.onrender.com/app-ads.txt` adresinin erişilebilir olduğunu kontrol edin



## Kullanım

### 📱 Mobil Uygulama
- **Ana Sayfa**: Günlük yemek menülerini görüntüleme
- **Filtreleme**: Şehir ve tarih bazlı menü filtreleme
- **Ayarlar**: Tema, dil ve bildirim ayarları
- **Bildirimler**: Yemek saatlerinde otomatik hatırlatmalar

### 🌐 Web Sitesi
- **Ana Sayfa**: Uygulama tanıtımı ve özellikler
- **İndirme Linki**: Google Play Store'a yönlendirme
- **AdMob Doğrulama**: app-ads.txt dosyası ile reklam doğrulaması

## AdMob Sorun Giderme

### Yaygın Sorunlar ve Çözümleri:

1. **"app-ads.txt dosyası bulunamadı" hatası:**
   - `app-ads.txt` dosyasının `yurttaye.onrender.com` kök dizininde olduğunu kontrol edin
   - Dosya içeriğinin doğru olduğunu doğrulayın: `google.com, pub-9589008379442992, DIRECT, f08c47fec0942fa0`

2. **"Publisher ID eşleşmiyor" hatası:**
   - AdMob hesabınızdaki Publisher ID'nin `pub-9589008379442992` olduğunu kontrol edin
   - AndroidManifest.xml dosyasındaki AdMob uygulama ID'sini kontrol edin

3. **"Alan adı doğrulanamadı" hatası:**
   - Google Play Console'da belirtilen alan adının `yurttaye.onrender.com` olduğunu kontrol edin
   - Web sitesinin erişilebilir olduğunu doğrulayın

## Katkıda Bulunma

Katkılarınızı bekliyoruz! Lütfen şu adımları takip edin:

1. Repository'yi fork edin
2. Yeni bir branch oluşturun (`git checkout -b feature/your-feature`)
3. Değişikliklerinizi commit edin (`git commit -m "Add your feature"`)
4. Branch'i push edin (`git push origin feature/your-feature`)
5. Pull request açın

## Lisans

Bu proje MIT Lisansı altında lisanslanmıştır.

## İletişim

Sorularınız veya geri bildirimleriniz için:

**Furkan Bulut** - BulutSoft Dev
- E-posta: bulutsoftdev@gmail.com
- GitHub: https://github.com/bulutsoft-dev
- Web Sitesi: https://yurttaye.onrender.com

## Bağlantılar

- **Google Play Store**: https://play.google.com/store/apps/details?id=com.yurttaye.yurttaye
- **Web Sitesi**: https://yurttaye.onrender.com
- **GitHub Repository**: https://github.com/bulutsoft-dev/Yurtta-Ye-Mobile

