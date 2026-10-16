import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

/// Custom Class for Light & Dark Text Themes
class AppTextTheme {
  // Material Light Theme Text Styles
  static TextTheme materialLightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.bold, color: AppColors.dark, fontFamily: AppColors.fontFamilyStatic),
    headlineMedium: const TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.w600, color: AppColors.dark, fontFamily: AppColors.fontFamilyStatic),
    headlineSmall: const TextStyle().copyWith(fontSize: 18.0, fontWeight: FontWeight.w600, color: AppColors.dark, fontFamily: AppColors.fontFamilyStatic),

    titleLarge: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w600, color: AppColors.dark, fontFamily: AppColors.fontFamilyStatic),
    titleMedium: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500, color: AppColors.dark, fontFamily: AppColors.fontFamilyStatic),
    titleSmall: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w400, color: AppColors.dark, fontFamily: AppColors.fontFamilyStatic),

    bodyLarge: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.dark, fontFamily: AppColors.fontFamilyStatic),
    bodyMedium: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.normal, color: AppColors.dark, fontFamily: AppColors.fontFamilyStatic),
    bodySmall: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.dark.withValues(alpha: 0.5), fontFamily: AppColors.fontFamilyStatic),

    labelLarge: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: AppColors.dark, fontFamily: AppColors.fontFamilyStatic),
    labelMedium: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: AppColors.dark.withValues(alpha: 0.5), fontFamily: AppColors.fontFamilyStatic),
  );

  // Material Dark Theme Text Styles
  static TextTheme materialDarkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.bold, color: AppColors.light, fontFamily: AppColors.fontFamilyStatic),
    headlineMedium: const TextStyle().copyWith(fontSize: 24.0, fontWeight: FontWeight.w600, color: AppColors.light, fontFamily: AppColors.fontFamilyStatic),
    headlineSmall: const TextStyle().copyWith(fontSize: 18.0, fontWeight: FontWeight.w600, color: AppColors.light, fontFamily: AppColors.fontFamilyStatic),

    titleLarge: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w600, color: AppColors.light, fontFamily: AppColors.fontFamilyStatic),
    titleMedium: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500, color: AppColors.light, fontFamily: AppColors.fontFamilyStatic),
    titleSmall: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w400, color: AppColors.light, fontFamily: AppColors.fontFamilyStatic),

    bodyLarge: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.light, fontFamily: AppColors.fontFamilyStatic),
    bodyMedium: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.normal, color: AppColors.light, fontFamily: AppColors.fontFamilyStatic),
    bodySmall: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: AppColors.light.withValues(alpha: 0.5), fontFamily: AppColors.fontFamilyStatic),

    labelLarge: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: AppColors.light, fontFamily: AppColors.fontFamilyStatic),
    labelMedium: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: AppColors.light.withValues(alpha: 0.5), fontFamily: AppColors.fontFamilyStatic),
  );

}

