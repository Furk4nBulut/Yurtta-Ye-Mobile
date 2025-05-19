import 'package:flutter/material.dart';

class Constants {
  static const String apiUrl = 'https://yurttaye.onrender.com/Api';

  // Tailwind-inspired color palette
  static const Color blue500 = Color(0xFF3B82F6); // Primary (replaces primaryColor)
  static const Color amber400 = Color(0xFFFBBF24); // Accent (replaces accentColor)
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray900 = Color(0xFF1F2A44);
  static const Color white = Color(0xFFFFFFFF);

  // Spacing scale (inspired by Tailwind's rem-based scale, 1 unit = 4px)
  static const double space1 = 4.0; // 0.25rem
  static const double space2 = 8.0; // 0.5rem
  static const double space3 = 12.0; // 0.75rem
  static const double space4 = 16.0; // 1rem
  static const double space6 = 24.0; // 1.5rem
  static const double space8 = 32.0; // 2rem

  // Font sizes (inspired by Tailwind's text scale)
  static const double textXs = 12.0; // text-xs
  static const double textSm = 14.0; // text-sm
  static const double textBase = 16.0; // text-base
  static const double textLg = 18.0; // text-lg
  static const double textXl = 20.0; // text-xl
  static const double text2xl = 24.0; // text-2xl
}