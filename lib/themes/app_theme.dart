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
      ),
      textTheme: GoogleFonts.robotoTextTheme(),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.grey[100],
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      ),
    );
  }
}