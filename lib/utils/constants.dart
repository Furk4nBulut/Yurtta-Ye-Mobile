import 'package:flutter/material.dart';

class Constants {
  static const String apiUrl = 'https://yurttaye.onrender.com/Api';

  // KYK-inspired color palette (Tailwind-like naming)
  static const Color kykBlue600 = Color(0xFF1E40AF); // Primary (KYK blue)
  static const Color kykYellow400 = Color(0xFFFBBF24); // Accent
  static const Color gray50 = Color(0xFFFAFAFA); // Surface
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray800 = Color(0xFF1F2A44);
  static const Color white = Color(0xFFFFFFFF);

  // Spacing scale (Tailwind-inspired, 1 unit = 4px)
  static const double space1 = 4.0; // 0.25rem
  static const double space2 = 8.0; // 0.5rem
  static const double space3 = 12.0; // 0.75rem
  static const double space4 = 16.0; // 1rem
  static const double space6 = 24.0; // 1.5rem
  static const double space8 = 32.0; // 2rem

  // Font sizes (Tailwind-inspired)
  static const double textXs = 12.0; // text-xs
  static const double textSm = 14.0; // text-sm
  static const double textBase = 16.0; // text-base
  static const double textLg = 18.0; // text-lg
  static const double textXl = 20.0; // text-xl
  static const double text2xl = 24.0; // text-2xl
}