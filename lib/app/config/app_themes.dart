import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppThemes {
  AppThemes._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    textTheme: GoogleFonts.poppinsTextTheme(),
    colorScheme: const ColorScheme.light(
      primary: AppColors.electricGreen,
      secondary: AppColors.accentLight,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.deepMidnight,
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.electricGreen,
      secondary: AppColors.accentLight,
    ),
  );
}

