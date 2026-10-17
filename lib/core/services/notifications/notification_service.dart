import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_bloc.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_event.dart';
import '../../../main.dart';
import '../../../presentation/cubit/notification_payload_cubit.dart';
import '../../navigation/navigation_handler.dart';
import '../../routes/app_routes.dart';
import 'notification_controller.dart';
import 'notification_display.dart';
import 'notification_payload.dart';

class NotificationService {
  static const _dummyData = {
    "request_id": "jfdsjssfdreiu#fkldjdlkfde",
    "keyring_category_id": "fmmmfdkdj",
    "keyring_category_name": "Murli Keyring Category Name", // ✅ correct key
    "otp": "123456",
  };

  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // ---------- Permissions ----------
  Future<void> requestNotificationPermission() async {
    // iOS + FCM permission
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );
    log('FCM permission: ${settings.authorizationStatus}');

    // Android 13+ / awesome permission
    final allowed = await AwesomeNotifications().isNotificationAllowed();
    if (!allowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // ---------- Awesome listeners (taps on local notifications) ----------
  Future<void> _setAwesomeListeners() async {
    await AwesomeNotifications().setListeners(
          onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
  }

  // ---------- Foreground FCM ----------
  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      log('Foreground notification: ${message.data}');

      // Use real data; fallback to dummy for testing
      final data = message.data.isNotEmpty ? message.data : _dummyData;

      final payload = NotificationPayload.fromMap(data);
      if (payload.isEmpty) return;

      // 1) Try to handle in-place (user is on keyring screen)
      final handledInPlace = NavigationHandler.handleForeground(payload);

      if (handledInPlace) {
        log('Showing in-place banner on keyring screen');
      //   return; // ✅ do NOT show system notification
      }


      if (Platform.isIOS) {
        foregroundMessage(); // iOS shows it natively
      }

      if (Platform.isAndroid) {
        NotificationDisplay.showNotification(message);
      }
    });
  }

  Future<void> setupInteractMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(data: initialMessage.data);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(data: event.data);
    });
  }

  // static void handleMessage({required Map<String, dynamic> data}) {
  //   try {
  //     final dummyData = {
  //       "request_id": "jfdsjfdreiu#fkldjdlkfde",
  //       "keyring_category_id": "fmmmfdkdj",
  //       "keyring_category_id": "Murli Keyring Category Name",
  //       "otp": "123456",
  //     };
  //
  //     print("User Tapped: $dummyData");
  //
  //     final payload = NotificationPayload.fromMap(dummyData);
  //     if (payload.isEmpty) return;
  //   } catch (e, st) {
  //     log('Error handling notification: $e', stackTrace: st);
  //   }
  // }
  static void handleMessage({required Map<String, dynamic> data}) {
    try {
      final payload = NotificationPayload.fromMap(
        data.isNotEmpty ? data : _dummyData,
      );
      if (payload.isEmpty) return;

      // If user is on keyring screen, set the payload so the banner appears
      final handled = NavigationHandler.handleForeground(payload);

      if (!handled) {
        rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.keyring,
              (_) => false,
        );
        rootNavigatorKey.currentContext
            ?.read<KeyringBloc>().add(AddNotificationPayloadEvent(payload));
      }
    } catch (e, st) {
      log('Error handling notification: $e', stackTrace: st);
    }
  }

  Future<void> foregroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<String?> getDeviceToken() async {
    try {
      return await messaging.getToken();
    } catch (e) {
      print("Error fetching FCM token: $e");
      return null;
    }
  }

  Future<void> clearAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  Future<void> notificationInitCall() async {
    await requestNotificationPermission();
    await foregroundMessage();
    await _setAwesomeListeners();
    firebaseInit();
    await setupInteractMessage();
  }
}

