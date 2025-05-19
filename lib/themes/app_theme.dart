import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    primaryColor: Colors.deepOrange,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepOrange,
      secondary: const Color(0xFFF5F5F5), // Beige
      tertiary: const Color(0xFF26A69A), // Teal
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    textTheme: GoogleFonts.robotoTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
        displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF333333)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF333333)),
        bodySmall: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    ),
    cardTheme: const CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.deepOrange,
      labelStyle: GoogleFonts.roboto(color: Colors.black),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepOrange,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  static const gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.deepOrange, Color(0xFF26A69A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static TextStyle get mealTitleStyle => GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle get mealSubtitleStyle => GoogleFonts.roboto(
    fontSize: 16,
    color: Colors.white70,
  );
}