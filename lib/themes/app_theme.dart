import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    primaryColor: Constants.kykBlue600, // Tailwind blue-600
    colorScheme: ColorScheme.fromSeed(
      seedColor: Constants.kykBlue600,
      primary: Constants.kykBlue600,
      secondary: Constants.kykYellow400, // Tailwind yellow-400
      tertiary: Constants.gray200, // Tailwind gray-200
      surface: Constants.white,
      background: Constants.gray50, // Tailwind gray-50
    ),
    scaffoldBackgroundColor: Constants.gray100, // Tailwind gray-100
    textTheme: GoogleFonts.poppinsTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: Constants.text2xl,
          fontWeight: FontWeight.w700,
          color: Constants.gray800,
        ),
        displayMedium: TextStyle(
          fontSize: Constants.textXl,
          fontWeight: FontWeight.w600,
          color: Constants.gray800,
        ),
        displaySmall: TextStyle(
          fontSize: Constants.textLg,
          fontWeight: FontWeight.w600,
          color: Constants.gray800,
        ),
        bodyLarge: TextStyle(
          fontSize: Constants.textBase,
          color: Constants.gray600,
        ),
        bodyMedium: TextStyle(
          fontSize: Constants.textSm,
          color: Constants.gray600,
        ),
        bodySmall: TextStyle(
          fontSize: Constants.textXs,
          color: Constants.gray600,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 3,
      color: Constants.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Softer corners
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(Constants.space2),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Constants.kykBlue600,
        foregroundColor: Constants.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.space4,
          vertical: Constants.space3,
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: Constants.textBase,
          fontWeight: FontWeight.w500,
        ),
        elevation: 2,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Constants.gray200,
      selectedColor: Constants.kykYellow400,
      checkmarkColor: Constants.gray800,
      labelStyle: GoogleFonts.poppins(
        fontSize: Constants.textSm,
        color: Constants.gray800,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.space2,
        vertical: Constants.space1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Constants.kykBlue600,
      foregroundColor: Constants.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: Constants.textXl,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Constants.white),
    ),
    iconTheme: IconThemeData(
      color: Constants.gray600,
      size: Constants.textBase,
    ),
  );

  static BoxDecoration get gradientDecoration => BoxDecoration(
    gradient: LinearGradient(
      colors: [Constants.kykBlue600, Constants.kykYellow400],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
  );

  static TextStyle get mealTitleStyle => GoogleFonts.poppins(
    fontSize: Constants.text2xl,
    fontWeight: FontWeight.w700,
    color: Constants.white,
  );

  static TextStyle get mealSubtitleStyle => GoogleFonts.poppins(
    fontSize: Constants.textBase,
    fontWeight: FontWeight.w400,
    color: Constants.white.withOpacity(0.9),
  );

  static TextStyle get categoryTitleStyle => GoogleFonts.poppins(
    fontSize: Constants.textLg,
    fontWeight: FontWeight.w600,
    color: Constants.kykBlue600,
  );
}