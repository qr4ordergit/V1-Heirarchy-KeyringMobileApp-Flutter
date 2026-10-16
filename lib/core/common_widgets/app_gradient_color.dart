import 'package:flutter/material.dart';

import '../config/app_config.dart';

class AppGradientBackground extends StatelessWidget {
  final Widget child;

  const AppGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withAlpha(200),
            Theme.of(context).primaryColor.withAlpha(100),
            Theme.of(context).primaryColor.withAlpha(30),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topLeft,
        ),
      ),
      child: child,
    );
  }
}