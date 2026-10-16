import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

class AppListTile extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final String? subtitle;
  final Widget? subtitleWidget;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? leading;
  final Widget? trailing;
  final double? minVerticalPadding;
  final double? radius;
  final double? minTileHeight;
  final double? contentPadding;
  final VisualDensity? visualDensity;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final Color? tileColor;
  final int? maxLines;

  const AppListTile({
    super.key,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.subtitleWidget,
    this.onTap,
    this.onLongPress,
    this.leading,
    this.trailing,
    this.minVerticalPadding,
    this.radius,
    this.minTileHeight,
    this.contentPadding,
    this.visualDensity,
    this.titleFontSize,
    this.titleFontWeight,
    this.maxLines,
    this.tileColor,
  }) : assert(title != null || titleWidget != null, 'Provide either title or titleWidget');

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress: onLongPress,
      contentPadding: contentPadding != null ? EdgeInsets.all(contentPadding!) : null,
      minVerticalPadding: minVerticalPadding,
      visualDensity: visualDensity,
      minTileHeight: minTileHeight,
      leading: leading,
      title: title != null
          ? Text(
        title!,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontSize: titleFontSize ?? Sizes.fontSizeSm,
          fontWeight: titleFontWeight ?? FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      )
          : titleWidget,
      subtitle: subtitle != null
          ? Text(subtitle!, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: Sizes.fontSizeXs), maxLines: maxLines , overflow: TextOverflow.ellipsis,)
          : subtitleWidget,
      trailing: trailing,
      tileColor: tileColor,
      shape: RoundedRectangleBorder(
        borderRadius: radius != null ? BorderRadius.circular(radius!) : BorderRadius.zero,
      ),
    );
  }
}