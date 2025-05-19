import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yurttaye_mobile/utils/constants.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    primaryColor: Constants.kykBlue600,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Constants.kykBlue600,
      brightness: Brightness.light,
      primary: Constants.kykBlue600,
      secondary: Constants.kykYellow400,
      tertiary: Constants.gray200,
      surface: Constants.white,
      background: Constants.gray50,
      error: Colors.red[600],
    ),
    scaffoldBackgroundColor: Constants.gray100,
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
      elevation: 2,
      color: Constants.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(
        vertical: Constants.space2,
        horizontal: Constants.space4,
      ),
      shadowColor: Constants.gray600.withOpacity(0.1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Constants.kykBlue600,
        foregroundColor: Constants.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.space4,
          vertical: Constants.space3,
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: Constants.textBase,
          fontWeight: FontWeight.w500,
        ),
        elevation: 3,
        shadowColor: Constants.gray600.withOpacity(0.2),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Constants.kykBlue600,
        side: BorderSide(color: Constants.gray200, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.space4,
          vertical: Constants.space3,
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: Constants.textBase,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Constants.gray100,
      selectedColor: Constants.kykYellow400,
      checkmarkColor: Constants.gray800,
      labelStyle: GoogleFonts.poppins(
        fontSize: Constants.textSm,
        color: Constants.gray800,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.space3,
        vertical: Constants.space2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Constants.gray200),
      ),
      elevation: 1,
      pressElevation: 4,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Constants.kykBlue600,
      foregroundColor: Constants.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: Constants.textXl,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(
        color: Constants.white,
        size: Constants.textXl,
      ),
      centerTitle: true,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Constants.white,
      selectedItemColor: Constants.kykYellow400,
      unselectedItemColor: Constants.gray600,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: Constants.textSm,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: Constants.textSm,
        fontWeight: FontWeight.w400,
      ),
      showUnselectedLabels: true,
      elevation: 8,
    ),
    iconTheme: IconThemeData(
      color: Constants.gray600,
      size: Constants.textBase,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    primaryColor: Constants.kykBlue600,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Constants.kykBlue600,
      brightness: Brightness.dark,
      primary: Constants.kykBlue600,
      secondary: Constants.kykYellow400,
      tertiary: Constants.gray600,
      surface: Constants.gray800,
      background: Constants.gray800,
      error: Colors.red[400],
    ),
    scaffoldBackgroundColor: Constants.gray800,
    textTheme: GoogleFonts.poppinsTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: Constants.text2xl,
          fontWeight: FontWeight.w700,
          color: Constants.white,
        ),
        displayMedium: TextStyle(
          fontSize: Constants.textXl,
          fontWeight: FontWeight.w600,
          color: Constants.white,
        ),
        displaySmall: TextStyle(
          fontSize: Constants.textLg,
          fontWeight: FontWeight.w600,
          color: Constants.white,
        ),
        bodyLarge: TextStyle(
          fontSize: Constants.textBase,
          color: Constants.gray100,
        ),
        bodyMedium: TextStyle(
          fontSize: Constants.textSm,
          color: Constants.gray100,
        ),
        bodySmall: TextStyle(
          fontSize: Constants.textXs,
          color: Constants.gray200,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      color: Constants.gray600,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(
        vertical: Constants.space2,
        horizontal: Constants.space4,
      ),
      shadowColor: Constants.gray800.withOpacity(0.3),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Constants.kykBlue600,
        foregroundColor: Constants.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.space4,
          vertical: Constants.space3,
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: Constants.textBase,
          fontWeight: FontWeight.w500,
        ),
        elevation: 3,
        shadowColor: Constants.gray800.withOpacity(0.3),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Constants.kykYellow400,
        side: BorderSide(color: Constants.gray200, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.space4,
          vertical: Constants.space3,
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: Constants.textBase,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Constants.gray600,
      selectedColor: Constants.kykYellow400,
      checkmarkColor: Constants.white,
      labelStyle: GoogleFonts.poppins(
        fontSize: Constants.textSm,
        color: Constants.white,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.space3,
        vertical: Constants.space2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Constants.gray200),
      ),
      elevation: 1,
      pressElevation: 4,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Constants.kykBlue600,
      foregroundColor: Constants.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: Constants.textXl,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(
        color: Constants.white,
        size: Constants.textXl,
      ),
      centerTitle: true,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Constants.gray600,
      selectedItemColor: Constants.kykYellow400,
      unselectedItemColor: Constants.gray100,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: Constants.textSm,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: Constants.textSm,
        fontWeight: FontWeight.w400,
      ),
      showUnselectedLabels: true,
      elevation: 8,
    ),
    iconTheme: IconThemeData(
      color: Constants.gray100,
      size: Constants.textBase,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  // Theme-aware custom styles
  static TextStyle mealTitleStyle(BuildContext context) => GoogleFonts.poppins(
    fontSize: Constants.text2xl,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).brightness == Brightness.dark
        ? Constants.white
        : Constants.white, // Always white for gradient background
  );

  static TextStyle mealSubtitleStyle(BuildContext context) => GoogleFonts.poppins(
    fontSize: Constants.textBase,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).brightness == Brightness.dark
        ? Constants.white.withOpacity(0.9)
        : Constants.white.withOpacity(0.9),
  );

  static TextStyle categoryTitleStyle(BuildContext context) => GoogleFonts.poppins(
    fontSize: Constants.textLg,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).brightness == Brightness.dark
        ? Constants.kykYellow400
        : Constants.kykBlue600,
  );

  static BoxDecoration gradientDecoration(BuildContext context) => BoxDecoration(
    gradient: LinearGradient(
      colors: [Constants.kykBlue600, Constants.kykYellow400],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration cardHoverDecoration(BuildContext context) => BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Constants.kykYellow400.withOpacity(
          Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.2,
        ),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );
}