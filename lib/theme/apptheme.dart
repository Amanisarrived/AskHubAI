import 'package:flutter/material.dart';

class AppTheme {
  static const Color backgroundcolor = Color(0xFF141718);
  static const Color primaryColor = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF232627);
  static const Color error = Colors.red;
  static const Color textlight = Color(0xFFACADB9);
}

class ApptextStyle {
  static const TextStyle heading = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.bold,
    color: AppTheme.primaryColor,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppTheme.primaryColor,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppTheme.textlight,
  );
}

final ThemeData apptheme = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: AppTheme.primaryColor,
    onPrimary: AppTheme.primaryColor,
    secondary: AppTheme.secondary,
    onSecondary: AppTheme.secondary,
    error: AppTheme.error,
    onError: AppTheme.error,
    surface: AppTheme.backgroundcolor,
    onSurface: AppTheme.backgroundcolor,
  ),
  textTheme: const TextTheme(
    headlineLarge: ApptextStyle.heading,
    bodyMedium: ApptextStyle.body,
    labelLarge: ApptextStyle.button,
  ),
);
