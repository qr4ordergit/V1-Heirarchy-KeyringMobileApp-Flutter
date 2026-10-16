import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keyring/core/constants/app_colors.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    if (isIOS) {
      return Transform.scale(
        scale: 0.9,
        child: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.green,
          thumbColor: AppColors.light,
        ),
      );
    }

    return Transform.scale(
      scale: 0.9,
      child: Switch(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
        value: value,
        activeTrackColor: Colors.green,
        thumbColor: const WidgetStatePropertyAll(AppColors.light),
        onChanged: onChanged,
      ),
    );
  }
}