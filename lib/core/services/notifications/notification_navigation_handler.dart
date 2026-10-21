import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_bloc.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_event.dart';
import '../../../data/models/notifications/notification_payload.dart';
import '../../../main.dart';
import '../../routes/app_route_observer.dart';
import '../../routes/app_routes.dart';

class ActiveKeyringTracker {
  static bool get isKeyringActive {
    // Check if the current top route is explicitly the keyring screen
    return appRouteObserver.currentRouteName == AppRoutes.keyring;
  }
}

class NotificationNavigationHandler {
  NotificationNavigationHandler._();
  static BuildContext? get _ctx => rootNavigatorKey.currentContext;


  static void handleMessage({required Map<String, dynamic> data}) {
    try {
      final payload = NotificationPayload.fromMap(data);

      if (payload.isEmpty) return;

      // If already on the keyring screen, handle it in place.
      final handled = sameScreenNotificationHandler(payload);

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

  // ── Foreground (app open) ─────────────────────────────────
  static bool sameScreenNotificationHandler(NotificationPayload payload) {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null || payload.isEmpty) return false;

    try {
      if (!ActiveKeyringTracker.isKeyringActive) return false;

      ctx.read<KeyringBloc>().add(
        AddNotificationPayloadEvent(payload),
      );

      return true;
    } catch (e, st) {
      log('handleForeground failed: $e', stackTrace: st);
      return false;
    }
  }

  static bool handleForegroundMessage({required Map<String, dynamic> data}) {
    try {
      final payload = NotificationPayload.fromMap(data);

      if (payload.isEmpty) return false;

      // User is already on the Keyring screen.
      if (sameScreenNotificationHandler(payload)) {
        log('User is on Keyring screen; handling in place not showing notification');
        return true;
      }

      // User is on another screen; dispatch event without navigating.
      _ctx?.read<KeyringBloc>().add(
        AddNotificationPayloadEvent(payload),
      );

      log('User is on another screen; event dispatched');

      return false;
    } catch (e, st) {
      log('Error handling foreground message: $e', stackTrace: st);
      return false;
    }
  }


}