import 'dart:ui';

class Constants {
  static const String apiUrl = 'https://yurttaye.onrender.com/Api';

  // KYK Kurumsal Renk Paleti
  static const Color kykPrimary = Color(0xFF1E3A8A);      // Koyu mavi - Ana renk
  static const Color kykSecondary = Color(0xFF3B82F6);    // Mavi - İkincil renk
  static const Color kykAccent = Color(0xFFF59E0B);       // Turuncu - Vurgu rengi
  static const Color kykSuccess = Color(0xFF10B981);      // Yeşil - Başarı
  static const Color kykWarning = Color(0xFFF59E0B);      // Turuncu - Uyarı
  static const Color kykError = Color(0xFFEF4444);        // Kırmızı - Hata
  
  // Nötr Renkler
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
  
  // Beyaz ve Şeffaflık
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  
  // Yemek Temalı Renkler
  static const Color foodWarm = Color(0xFFFF6B35);        // Sıcak yemek rengi
  static const Color foodFresh = Color(0xFF4ADE80);       // Taze yeşil
  static const Color foodSweet = Color(0xFFF472B6);       // Tatlı pembe
  static const Color foodSpicy = Color(0xFFDC2626);       // Baharatlı kırmızı

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

  static const Color gray800 = Color(0xFF0F1F3B);      // Çok koyu mavi
  static const Color gray900 = Color(0xFF0A1525);      // Siyaha yakın koyu mavi
}