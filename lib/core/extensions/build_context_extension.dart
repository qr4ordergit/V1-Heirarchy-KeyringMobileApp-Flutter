import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  /// True when the current theme brightness is dark.
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  /// Screen width in logical pixels.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Screen height in logical pixels.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Device orientation, based on the actual screen dimensions —
  /// NOT keyboard visibility (see [isKeyboardVisible] for that).
  bool get isLandscape => MediaQuery.orientationOf(this) == Orientation.landscape;

  bool get isPortrait => MediaQuery.orientationOf(this) == Orientation.portrait;

  /// Height in logical pixels currently occupied by the on-screen keyboard
  /// (0.0 when hidden). This is the raw inset value — prefer
  /// [isKeyboardVisible] when you only need a yes/no check.
  double get keyboardHeight => MediaQuery.viewInsetsOf(this).bottom;

  /// Whether the on-screen keyboard is currently showing.
  bool get isKeyboardVisible => keyboardHeight > 0;

  /// Dismisses the on-screen keyboard, if visible.
  void hideKeyboard() => FocusScope.of(this).requestFocus(FocusNode());


// static bool isDesktopScreen(BuildContext context) {
//   return MediaQuery.of(context).size.width >= Sizes.desktopScreenSize;
// }
//
// static bool isTabletScreen(BuildContext context) {
//   return MediaQuery.of(context).size.width >= Sizes.tabletScreenSize && MediaQuery.of(context).size.width < Sizes.desktopScreenSize;
// }
//
// static bool isMobileScreen(BuildContext context) {
//   return MediaQuery.of(context).size.width < Sizes.tabletScreenSize;
// }
}