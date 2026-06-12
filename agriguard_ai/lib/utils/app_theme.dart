import 'package:flutter/material.dart';

/// Agricultural palette: earth, growth, harvest.
abstract final class AgriColors {
  static const forestGreen = Color(0xFF2D6A4F);
  static const leafGreen = Color(0xFF40916C);
  static const mintGreen = Color(0xFF95D5B2);
  static const soilBrown = Color(0xFF5C4033);
  static const wheatGold = Color(0xFFD4A017);
  static const cream = Color(0xFFF8F6F0);
  static const skyBlue = Color(0xFF4A90A4);
  static const dangerRed = Color(0xFFC0392B);
}

ThemeData buildAgriTheme() {
  const seed = AgriColors.forestGreen;

  final colorScheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
    primary: AgriColors.forestGreen,
    onPrimary: Colors.white,
    secondary: AgriColors.leafGreen,
    onSecondary: Colors.white,
    tertiary: AgriColors.wheatGold,
    surface: Colors.white,
    onSurface: AgriColors.soilBrown,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AgriColors.cream,
    appBarTheme: const AppBarTheme(
      backgroundColor: AgriColors.forestGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AgriColors.forestGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AgriColors.forestGreen,
        side: const BorderSide(color: AgriColors.leafGreen),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AgriColors.leafGreen, width: 2),
      ),
      labelStyle: const TextStyle(color: AgriColors.soilBrown),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: AgriColors.forestGreen.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
