import 'package:flutter/material.dart';
import 'package:keyring/core/constants/app_sizes.dart';

import '../constants/app_colors.dart';
import '../device/device_utility.dart';
import '../extensions/build_context_extension.dart';

// icon + label
// only label
class ButtonWidget extends StatelessWidget {
  const ButtonWidget({super.key,
    this.icon,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.iconColor,
    this.iconSize,
    this.buttonHeight,
    this.buttonWidth,
    this.radius,
    this.fontSize,
    this.isLoading = false,
  });

  final void Function()? onPressed;
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? iconColor;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? iconSize;
  final double? radius;
  final double? fontSize;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            shadowColor: backgroundColor != null ? Colors.transparent : null,
            surfaceTintColor: backgroundColor != null ? Colors.transparent : null,
            elevation: backgroundColor != null ? 0 : null,
            backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              side: borderColor == null ? BorderSide.none : BorderSide(color: borderColor!),
                borderRadius: BorderRadius.circular(radius ?? Sizes.borderRadiusLg),
            ),
        ),
        icon: (isLoading == false && icon != null) ? Icon(icon, color: textColor ?? AppColors.dark, size: iconSize) : null,
        // icon: (isLoading == false && icon != null) ? Icon(icon, color: textColor ?? (context.isDarkTheme ? null : AppColors.light), size: iconSize) : null,
          onPressed: isLoading == true ? null : onPressed,
          label: isLoading == true ? DeviceUtility.loadingWidget(color: AppColors.light) : Text(
              label.toString(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: fontSize, fontWeight: FontWeight.w600, color: textColor ?? AppColors.dark)
              // style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: fontSize, color: textColor ?? (context.isDarkTheme ? null : AppColors.dark))
          ),
      ),
    );
  }
}
