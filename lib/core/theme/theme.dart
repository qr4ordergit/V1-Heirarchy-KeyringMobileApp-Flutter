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
    // cardColor: Colors.grey.withValues(alpha: 0.2),
    // scaffoldBackgroundColor: AppColors.white,
    // appBarTheme: AppBarTheme(
    //     backgroundColor: AppColors.white,
    //     foregroundColor: AppColors.black
    // ),
    // floatingActionButtonTheme: FloatingActionButtonThemeData(
    //   backgroundColor: primaryColor,
    //   foregroundColor: AppColors.light,
    // ),
    //
    // segmentedButtonTheme: SegmentedButtonThemeData(
    //   style: SegmentedButton.styleFrom(
    //     selectedBackgroundColor: primaryColor,
    //     selectedForegroundColor: AppColors.light,
    //     foregroundColor: AppColors.grey,
    //     side: BorderSide(
    //         color: AppColors.greyShade
    //     ),
    //   ),
    // ),

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
    // cardColor: primaryColor.withValues(alpha: 0.03),
    cardColor: AppColors.cardColor,
    scaffoldBackgroundColor: AppColors.scaffoldBgColor,
    appBarTheme: AppBarTheme(backgroundColor: Colors.transparent, foregroundColor: AppColors.light),
    // floatingActionButtonTheme: FloatingActionButtonThemeData(
    //   backgroundColor: primaryColor.withValues(alpha: 0.3),
    //   foregroundColor: AppColors.light,
    // ),
    //
    // segmentedButtonTheme: SegmentedButtonThemeData(
    //   style: SegmentedButton.styleFrom(
    //     selectedBackgroundColor: primaryColor.withValues(alpha: 0.3),
    //     selectedForegroundColor: AppColors.light,
    //     side: BorderSide(
    //         color: AppColors.greyShade
    //     ),
    //   ),
    // ),


  );

}