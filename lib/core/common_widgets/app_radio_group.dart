import 'package:flutter/material.dart';

/// Generic radio-group layout: renders a [RadioGroup] with one item per
/// value, built via [itemBuilder]. Keeps radio-selection screens (settings,
/// filters, etc.) consistent without repeating the RadioGroup boilerplate.
class AppRadioGroup<T> extends StatelessWidget {
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final List<T> values;
  final Widget Function(T value) itemBuilder;

  const AppRadioGroup({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.values,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      groupValue: groupValue,
      onChanged: onChanged,
      child: Column(
        children: values.map(itemBuilder).toList(),
      ),
    );
  }
}