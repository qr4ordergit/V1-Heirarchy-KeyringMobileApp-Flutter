import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class DefaultProfileAvatar extends StatelessWidget {
  final String? text;
  final double? radius;
  final Color? backgroundColor;
  final Color? textColor;

  const DefaultProfileAvatar({super.key, this.text, this.textColor, this.radius, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Theme.of(context).cardColor,
      child: text != null
          ? Text(
        text!,
        style: Theme.of(context).textTheme.titleSmall,
      )
          : null,
    );
  }
}