import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_bloc.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_event.dart';
import '../../../data/models/notifications/notification_payload.dart';
import '../../../main.dart';
import '../../navigation/navigation_handler.dart';
import '../../routes/app_routes.dart';


class NotificationNavigationHandler {
  static void handleMessage({
    required Map<String, dynamic> data,
  }) {
    try {
      final payload = NotificationPayload.fromMap(data);

      if (payload.isEmpty) return;

      // If already on the keyring screen, handle it in place.
      final handled = NavigationHandler.handleForeground(payload);

      if (handled) return;

      final navigator = rootNavigatorKey.currentState;
      if (navigator == null) {
        log('Navigator not ready; notification needs to be queued.');
        return;
      }

      navigator.pushNamedAndRemoveUntil(
        AppRoutes.keyring,
            (_) => false,
      );

      // Dispatch after navigation, when the destination is ready.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        rootNavigatorKey.currentContext
            ?.read<KeyringBloc>()
            .add(AddNotificationPayloadEvent(payload));
      });
    } catch (e, st) {
      log('Error handling notification: $e', stackTrace: st);
    }
  }
}

// static void handleMessage({required Map<String, dynamic> data}) {
// try {
//
// final payload = NotificationPayload.fromMap(data);
// if (payload.isEmpty) return;
//
// // If user is on keyring screen, set the payload so the banner appears
// final handled = NavigationHandler.handleForeground(payload);
//
// if (!handled) {
// rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
// AppRoutes.keyring,
// (_) => false,
// );
// rootNavigatorKey.currentContext
//     ?.read<KeyringBloc>().add(AddNotificationPayloadEvent(payload));
// }
// } catch (e, st) {
// log('Error handling notification: $e', stackTrace: st);
// }
// }