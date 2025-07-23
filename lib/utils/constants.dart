import 'dart:ui';

class Constants {
  static const String apiUrl = 'https://yurttaye.onrender.com/Api';
  static const String apiKey = 'YOUR_API_KEY_HERE'; // Add your actual API key here

  // KYK Kurumsal Renk Paleti
  static const Color kykPrimary = Color(0xFF1E3A8A);      // Koyu mavi - Ana renk
  static const Color kykSecondary = Color(0xFF3B82F6);    // Mavi - İkincil renk
  static const Color kykAccent = Color(0xFFF59E0B);       // Turuncu - Vurgu rengi
  static const Color kykSuccess = Color(0xFF10B981);      // Yeşil - Başarı
  static const Color kykWarning = Color(0xFFF59E0B);      // Turuncu - Uyarı
  static const Color kykError = Color(0xFFEF4444);        // Kırmızı - Hata
  
  // Nötr Renkler - Aydınlık Tema
  static const Color kykGray50 = Color(0xFFF8FAFC);       // Çok açık gri
  static const Color kykGray100 = Color(0xFFF1F5F9);      // Açık gri
  static const Color kykGray200 = Color(0xFFE2E8F0);      // Orta açık gri
  static const Color kykGray300 = Color(0xFFCBD5E1);      // Orta gri
  static const Color kykGray400 = Color(0xFF94A3B8);      // Orta koyu gri
  static const Color kykGray500 = Color(0xFF64748B);      // Koyu gri
  static const Color kykGray600 = Color(0xFF475569);      // Daha koyu gri
  static const Color kykGray700 = Color(0xFF334155);      // Çok koyu gri
  static const Color kykGray800 = Color(0xFF1E293B);      // En koyu gri
  static const Color kykGray900 = Color(0xFF0F172A);      // Siyaha yakın
  
  // Karanlık Tema İçin Özel Renkler - Daha Yumuşak ve Modern
  static const Color darkBackground = Color(0xFF0A0A0A);      // Çok koyu arka plan
  static const Color darkSurface = Color(0xFF1A1A1A);         // Koyu yüzey
  static const Color darkCard = Color(0xFF2A2A2A);            // Koyu kart
  static const Color darkBorder = Color(0xFF3A3A3A);          // Koyu kenarlık
  static const Color darkTextPrimary = Color(0xFFF5F5F5);     // Ana metin rengi
  static const Color darkTextSecondary = Color(0xFFB0B0B0);   // İkincil metin rengi
  static const Color darkTextTertiary = Color(0xFF808080);    // Üçüncül metin rengi
  static const Color darkDivider = Color(0xFF404040);         // Ayırıcı çizgi
  static const Color darkHover = Color(0xFF353535);           // Hover durumu
  static const Color darkActive = Color(0xFF404040);          // Aktif durum
  
  // Karanlık Tema İçin Yumuşak Renkler
  static const Color darkBlue = Color(0xFF1E293B);            // Yumuşak koyu mavi
  static const Color darkBlueLight = Color(0xFF334155);       // Açık koyu mavi
  static const Color darkBlueLighter = Color(0xFF475569);     // Daha açık koyu mavi
  static const Color darkGray = Color(0xFF374151);            // Yumuşak koyu gri
  static const Color darkGrayLight = Color(0xFF4B5563);       // Açık koyu gri
  static const Color darkGrayLighter = Color(0xFF6B7280);     // Daha açık koyu gri
  
  // Beyaz ve Şeffaflık
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  // Yemek Temalı Renkler
  static const Color foodWarm = Color(0xFFFF6B35);        // Sıcak yemek rengi
  static const Color foodFresh = Color(0xFF4ADE80);       // Taze yeşil
  static const Color foodSweet = Color(0xFFF472B6);       // Tatlı pembe
  static const Color foodSpicy = Color(0xFFDC2626);       // Baharatlı kırmızı

  // Sabah Yemeği Özel Renkleri
  static const Color breakfastPrimary = Color(0xFFFF8A65);    // Sabah turuncu
  static const Color breakfastSecondary = Color(0xFFFFCC02);  // Sabah sarısı
  static const Color breakfastAccent = Color(0xFFFF6F61);     // Sabah mercan
  static const Color breakfastWarm = Color(0xFFFFB74D);       // Sabah sıcak turuncu
  static const Color breakfastLight = Color(0xFFFFE0B2);      // Sabah açık sarı
  static const Color breakfastGradientStart = Color(0xFFFF8A65); // Sabah gradient başlangıç
  static const Color breakfastGradientEnd = Color(0xFFFFCC02);   // Sabah gradient bitiş

  // Akşam Yemeği Özel Renkleri
  static const Color dinnerPrimary = Color(0xFF1E3A8A);       // Eski mavi - Ana renk
  static const Color dinnerSecondary = Color(0xFF3B82F6);     // Eski mavi - İkincil renk
  static const Color dinnerAccent = Color(0xFFF59E0B);        // Turuncu - Vurgu rengi
  static const Color dinnerWarm = Color(0xFF2C4C9E);          // Eski mavi - Sıcak ton
  static const Color dinnerLight = Color(0xFFEFF3FF);         // Eski açık mavi
  static const Color dinnerGradientStart = Color(0xFF1E3A8A); // Eski mavi gradient başlangıç
  static const Color dinnerGradientEnd = Color(0xFF3B82F6);   // Eski mavi gradient bitiş

  // Öğle Yemeği Özel Renkleri
  static const Color lunchPrimary = Color(0xFF4CAF50);        // Öğle yeşil
  static const Color lunchSecondary = Color(0xFF66BB6A);      // Öğle açık yeşil
  static const Color lunchAccent = Color(0xFF2E7D32);         // Öğle koyu yeşil
  static const Color lunchWarm = Color(0xFF81C784);           // Öğle sıcak yeşil
  static const Color lunchLight = Color(0xFFE8F5E8);          // Öğle açık yeşil
  static const Color lunchGradientStart = Color(0xFF4CAF50);  // Öğle gradient başlangıç
  static const Color lunchGradientEnd = Color(0xFF66BB6A);    // Öğle gradient bitiş

  // Eski renkler (geriye uyumluluk için)
  static const Color kykBlue900 = Color(0xFF162A4D);   // Koyu lacivert, derinlik için
  static const Color kykBlue600 = Color(0xFF2C4C9E);   // Canlı orta mavi
  static const Color kykBlue400 = Color(0xFF5A7FE3);   // Parlak orta açık mavi
  static const Color kykBlue200 = Color(0xFFB6CCFF);   // Çok açık gökyüzü mavisi, ferahlatıcı
  static const Color kykOrange400 = Color(0xFF8257E5); // Canlı mor-menekşe tonu
  static const Color kykYellow400 = Color(0xFFE25757); // Soft kırmızı - vurgu ve dikkat için
  static const Color kykGray100_old = Color(0xFFEFF3FF);   // Çok açık buz mavisi
  static const Color gray50 = Color(0xFFF8FAFF);       // Neredeyse beyaz, hafif mavi
  static const Color gray100 = Color(0xFFD7E1FF);      // Açık mavi-gri
  static const Color gray200 = Color(0xFFACBAF7);      // Hafif mavi tonlu gri
  static const Color gray300 = Color(0xFF8399E3);      // Orta mavi-gri
  static const Color gray500 = Color(0xFF516DC0);      // Koyu mavi-gri (metinlerde yumuşak)
  static const Color gray600 = Color(0xFF3E5396);      // Daha koyu mavi-gri (başlık/metin)
  static const Color kykGray700_old = Color(0xFF2B3B70);   // Koyu mavi-gri
  static const Color gray700 = Color(0xFF1A2A54);      // Çok koyu mavi-gri
  static const Color kykRed600 = Color(0xFFB33838);    // Orta koyu kırmızı
  static const Color kykRed400 = Color(0xFFDB5959);    // Parlak kırmızı
  static const Color kykGreen400 = Color(0xFF3EA66B);  // Canlı yeşil

  // Boşluk ve yazı büyüklükleri (değişmedi)
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space8 = 32.0;

  static const double textXs = 12.0;
  static const double textSm = 14.0;
  static const double textBase = 16.0;
  static const double textLg = 18.0;
  static const double textXl = 20.0;
  static const double text2xl = 24.0;
  static const double text3xl = 30.0;

  static const Color gray800 = Color(0xFF0F1F3B);      // Çok koyu mavi
  static const Color gray900 = Color(0xFF0A1525);      // Siyaha yakın koyu mavi

  // Yemek türü sabitleri
  static const String breakfastType = 'breakfast';
  static const String lunchType = 'lunch';
  static const String dinnerType = 'dinner';
}