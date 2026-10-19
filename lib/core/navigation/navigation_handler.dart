import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_bloc.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_event.dart';
import '../../main.dart';
import '../../presentation/cubit/notification_payload_cubit.dart';
import '../../data/models/notifications/notification_payload.dart';

class ActiveKeyringTracker {
  bool isKeyringScreen = false;

  bool get isActive => isKeyringScreen;
}

class NavigationHandler {
  NavigationHandler._();

  static BuildContext? get _ctx => rootNavigatorKey.currentContext;

  // ── Foreground (app open) ─────────────────────────────────
  static bool handleForeground(NotificationPayload p) {
    final ctx = _ctx;
    if (ctx == null || p.isEmpty) return false;

    try {
      final tracker = ctx.read<ActiveKeyringTracker>();
      if (!tracker.isActive) return false;

      ctx.read<KeyringBloc>().add(AddNotificationPayloadEvent(p));
      return true;
    } catch (e) {
      print('handleForeground failed: $e');
      return false;
    }
  }

}

