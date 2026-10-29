import 'package:flutter/material.dart';

class AppColors  {
  static const String fontFamilyStatic = 'Poppins';

  // Background colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF010101);
  // static const Color scaffoldBgColor = Color(0xFF131628);
  // static const Color cardColor = Color(0xFF242940);

  static const Color scaffoldBgColor = Color(0xFF050505);
  static const Color cardColor = Color(0xFF171320);

  // Error and validation colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color green = Color(0xFF00E50B);
  static const Color orange = Color(0xFFF14916);
  static const Color red = Color(0xFFF62A2A);

  static const primary     = Color(0xFF1A3A5C);
  static const secondary   = Color(0xFF4A7FB5);
  static const background  = Color(0xFFDAE8F5);
  static const white       = Colors.white;
  static const grey = Colors.grey;
  static const cardBorder  = Color(0xFF4A7FB5);
  static const textDark    = Color(0xFF1A3A5C);
  static const textLight   = Color(0xFF2C5282);

  // static final teal = Color(0xFF00BFA5);
  static final greyShade = grey.withValues(alpha: 0.2);
  static final lightGreen = Color.lerp(AppColors.green, Colors.white, 0.4);

}