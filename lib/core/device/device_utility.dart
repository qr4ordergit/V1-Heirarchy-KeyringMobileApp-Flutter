import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import '../config/app_config.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class DeviceUtility {
  DeviceUtility._();

  static Widget loadingWidget({Color? color}) {
    return CupertinoActivityIndicator(color: color);
  }

  static Widget divider({Color? color}) {
    return Container(
      height: 0.5,
      color: color ?? AppColors.grey.withAlpha(100),
      margin: const EdgeInsets.symmetric(vertical: Sizes.sm),
    );
  }

  // static List<TextSpan> getRichTextSpans(
  //     String text,
  //     TextStyle? textStyle, {
  //       String? actionText,
  //       double? fontSize,
  //       VoidCallback? onActionTap,
  //     }) {
  //   return [
  //     TextSpan(text: text, style: textStyle),
  //     if (actionText != null)
  //       TextSpan(
  //         text: actionText,
  //         style: (textStyle ?? const TextStyle()).copyWith(
  //           color: primaryColor,
  //           fontWeight: FontWeight.w600,
  //           fontSize: fontSize,
  //         ),
  //         recognizer: TapGestureRecognizer()..onTap = onActionTap,
  //       ),
  //   ];
  // }

  static Future<void> setStatusBarColor(Color color) async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color),
    );
  }

  static void setFullScreen(bool enable) {
    SystemChrome.setEnabledSystemUIMode(
      enable ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
  }
}