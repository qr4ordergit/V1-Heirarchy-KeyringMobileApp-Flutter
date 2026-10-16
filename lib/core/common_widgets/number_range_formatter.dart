import 'package:flutter/services.dart';

class NumberRangeFormatter extends TextInputFormatter {
  final int min;
  final int max;

  NumberRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) return newValue;

    final number = int.tryParse(newValue.text);
    if (number == null) return oldValue;
    if (number < min || number > max) return oldValue;

    return newValue;
  }
}
