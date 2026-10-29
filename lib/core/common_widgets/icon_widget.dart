import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../device/device_utility.dart';
import '../extensions/build_context_extension.dart';

class IconWidget extends StatelessWidget {
  const IconWidget({
    super.key,
    required this.icon,
    this.onTap,
    this.isLoading,
    this.iconColor,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.paddingTop = 0.0,
    this.paddingBottom = 0.0,
    this.paddingAll,
    this.iconSize,
    this.backgroundColor,
    this.borderColor,
    this.radius,
    this.tooltip,
  });

  final void Function()? onTap;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? paddingAll;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final double? iconSize;
  final double? radius;
  final bool? isLoading;
  final String? tooltip;

  EdgeInsets get _padding {
    if (paddingAll != null) {
      return EdgeInsets.all(paddingAll!);
    }

    return EdgeInsets.only(
      left: paddingLeft,
      right: paddingRight,
      top: paddingTop,
      bottom: paddingBottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      onTap: isLoading == true ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: borderColor != null ? Border.all(color: borderColor!, width:0.9) : null,
          borderRadius: BorderRadius.circular(radius ?? 0),
        ),
        padding: _padding,
        child: isLoading == true
            ? DeviceUtility.loadingWidget()
            : Icon(
          icon,
          color: iconColor ??
              Theme.of(context).primaryColor,
          size: iconSize,
        ),
      ),
    );

    if (tooltip == null || tooltip!.isEmpty) {
      return child;
    }

    return Tooltip(
      message: tooltip!,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(
          Sizes.borderRadiusMd,
        ),
      ),
      textStyle: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(
        color: context.isDarkTheme
            ? AppColors.light
            : AppColors.dark,
        fontWeight: FontWeight.w500,
        fontSize: Sizes.fontSizeSm - 2,
      ),
      child: child,
    );
  }
}