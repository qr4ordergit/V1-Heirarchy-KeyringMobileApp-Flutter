import 'package:flutter/material.dart';
import 'package:keyring/presentation/screens/dashboard/keyring/keyring_details_screen.dart';
import 'package:keyring/presentation/screens/devices/devices_screen.dart';
import '../../data/models/keyring/keyring_model.dart';
import '../../presentation/screens/auth/sign_in_screen.dart';
import '../../presentation/screens/dashboard/keyring/keyring_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String signIn = '/signin';
  static const String keyring = '/keyrings';
  static const String devices = '/devices';
  static const String keyringDetails = '/keyring-details';

  static Map<String, WidgetBuilder> routes = {
    signIn: (context) => const SignInScreen(),

    keyring: (context) => KeyringScreen(),

    devices: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;

      final isNavigate = args is Map<String, dynamic>
          ? args['isNavigate'] as bool? ?? true
          : true;

      return DevicesScreen(isNavigate: isNavigate);
    },

    keyringDetails: (context) {
      final args = ModalRoute.of(context)!.settings.arguments
      as Map<String, dynamic>;

      return KeyringDetailsScreen(
        keyringData: args['keyringData'] as KeyringData,
      );
    },
  };
}