import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../constants/app_sizes.dart';

/// icon + label row, e.g. for cancel/action buttons inside
class IconTitleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? titleColor;

  const IconTitleRow({
    super.key,
    required this.icon,
    required this.title,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: titleColor),
        const SizedBox(width: Sizes.sm),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: Sizes.fontSizeSm,
            color: titleColor ?? Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}