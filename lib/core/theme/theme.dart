import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../constants/app_colors.dart';
import 'widget_themes/text_theme.dart';

// theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),

class AppTheme {

  static ThemeData materialLightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: AppColors.fontFamilyStatic,
    textTheme: AppTextTheme.materialLightTextTheme,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
      cardColor: primaryColor.withValues(alpha: 0.03)
  );

  static ThemeData materialDarkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: AppColors.fontFamilyStatic,
    textTheme: AppTextTheme.materialDarkTextTheme,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    cardColor: AppColors.cardColor,
    scaffoldBackgroundColor: AppColors.scaffoldBgColor,
    appBarTheme: AppBarTheme(backgroundColor: Colors.transparent, foregroundColor: AppColors.light),
  );

}
