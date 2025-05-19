import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: Constants.primaryColor,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        accentColor: Constants.accentColor,
        backgroundColor: const Color(0xFFF5F5F5),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      textTheme: GoogleFonts.robotoTextTheme(
        TextTheme(
          titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF212121)),
          titleMedium: const TextStyle(fontSize: 16, color: Color(0xFF757575)),
          bodyMedium: const TextStyle(fontSize: 14, color: Color(0xFF212121)),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Constants.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}