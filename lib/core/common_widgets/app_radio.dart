import 'package:flutter/material.dart';
import '../config/app_config.dart';

class AppRadio<T> extends StatelessWidget {
  final T value;

  const AppRadio({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Radio<T>(
      value: value,
      activeColor: Theme.of(context).primaryColor,
    );
  }
}