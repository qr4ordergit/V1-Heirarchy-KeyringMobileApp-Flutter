import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../../navigation/navigation_handler.dart';
import 'notification_controller.dart';
import '../../../data/models/notifications/notification_payload.dart';
import 'notification_display.dart';
import 'notification_navigation_handler.dart';

class NotificationService {
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
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );
  }

  // ---------- Foreground FCM ----------
  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      log('Foreground notification: ${message.data}');

      // Use real data; fallback to dummy for testing
      final data = message.data;
      // final data = message.data.isNotEmpty ? message.data : ;

      final payload = NotificationPayload.fromMap(data);
      if (payload.isEmpty) return;

      // 1) Try to handle in-place (user is on keyring screen)
      final handledInPlace = NavigationHandler.handleForeground(payload);

      if (handledInPlace) {
        log('Showing in-place banner on keyring screen');
      //   return;
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
      NotificationNavigationHandler.handleMessage(
        data: initialMessage.data,
      );
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("When User tap on notification: ${event.data}");
      NotificationNavigationHandler.handleMessage(
        data: event.data,
      );
    });
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

