import 'package:flutter/material.dart';
import '../common_widgets/icon_widget.dart';
import '../constants/app_sizes.dart';

// popup menu (three-dot / overflow menu) with consistent shape,
class AppPopupMenu<T> extends StatelessWidget {
  final IconData icon;
  final List<PopupMenuEntry<T>> items;
  final ValueChanged<T> onSelect;
  final void Function()? onTap;
  final Color? iconColor;
  final Color? iconBgColor;
  final EdgeInsetsGeometry? padding;

  const AppPopupMenu({
    super.key,
    required this.icon,
    required this.items,
    required this.onSelect,
    this.iconColor,
    this.iconBgColor,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      padding: padding ??  EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      ),
      icon: IconWidget(
        icon: icon,
        paddingAll: Sizes.sm,
        radius: Sizes.circularRadius,
        iconColor: iconColor,
        backgroundColor: iconBgColor,
        onTap: onTap,
      ),
      offset: const Offset(0, 40),
      onSelected: onSelect,
      itemBuilder: (BuildContext context) => items,
    );
  }
}