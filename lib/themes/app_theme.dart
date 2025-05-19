import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Constants.blue500,
        primary: Constants.blue500,
        secondary: Constants.amber400,
        surface: Constants.gray100,
        onSurface: Constants.gray900,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Constants.gray100,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineMedium: TextStyle(
          fontSize: Constants.text2xl,
          fontWeight: FontWeight.w700,
          color: Constants.gray900,
        ),
        titleLarge: TextStyle(
          fontSize: Constants.textXl,
          fontWeight: FontWeight.w600,
          color: Constants.gray900,
        ),
        bodyMedium: TextStyle(
          fontSize: Constants.textBase,
          color: Constants.gray700,
        ),
        bodySmall: TextStyle(
          fontSize: Constants.textSm,
          color: Constants.gray700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        color: Constants.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(
          horizontal: Constants.space4,
          vertical: Constants.space2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Constants.white,
          backgroundColor: Constants.blue500,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(
            horizontal: Constants.space4,
            vertical: Constants.space3,
          ),
          textStyle: TextStyle(
            fontSize: Constants.textBase,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Constants.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Constants.gray200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Constants.gray200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Constants.blue500, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Constants.space4,
          vertical: Constants.space3,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Constants.blue500,
        foregroundColor: Constants.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: Constants.textXl,
          fontWeight: FontWeight.w600,
          color: Constants.white,
        ),
        centerTitle: true,
      ),
      dividerTheme: DividerThemeData(
        color: Constants.gray200,
        thickness: 1,
        space: Constants.space2,
      ),
    );
  }
}