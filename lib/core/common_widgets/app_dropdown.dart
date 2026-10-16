import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../constants/app_sizes.dart';
import '../device/device_utility.dart';
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.initialValue,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.labelText,
    this.validator,
    this.enabled = true,
    this.isLoading = false,
  });

  final T? initialValue;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  final String? hintText;
  final String? labelText;
  final String? Function(T?)? validator;
  final bool enabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: initialValue,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      icon: isLoading ? DeviceUtility.loadingWidget() : Icon(Iconsax.arrow_circle_down_copy, size: Sizes.iconSm),
      style: Theme.of(context).textTheme.labelLarge,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        labelText: labelText,
        filled: true,
        fillColor: Theme.of(context).cardColor,
        // border: AppBorders.rounded(),
        // enabledBorder: AppBorders.rounded(),
        // focusedBorder: AppBorders.rounded(),
        // errorBorder: AppBorders.rounded(),
      ),
    );
  }
}