import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'notification_controller.dart';
import 'notification_display.dart';
import 'notification_navigation_handler.dart';
import 'request_notification_ids.dart';

class NotificationService {
  NotificationService._();

  static final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // ---------- Permissions ----------
  static Future<void> requestNotificationPermission() async {
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
  static Future<void> _setAwesomeListeners() async {
    await AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );
  }

  // ---------- Foreground FCM ----------
  static void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      final data = message.data;
      log('Foreground notification: $data');

      final handledOnKeyring = NotificationNavigationHandler.handleForegroundMessage(
        data: message.data,
      );

      // Show/Hide Notification
      // if (handledOnKeyring) return;

      if (Platform.isIOS) {
        foregroundMessage(); // iOS shows it natively
      }

      if (Platform.isAndroid) {
        NotificationDisplay.showNotification(message);
      }
    });
  }

  static Future<void> setupInteractMessage() async {
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

  static Future<void> foregroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<String?> getDeviceToken() async {
    try {
      return await messaging.getToken();
    } catch (e) {
      print("Error fetching FCM token: $e");
      return null;
    }
  }

  static Future<void> clearAllNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  static Future<void> clearSpecificNotification({required String id}) async {
    await AwesomeNotifications().cancel(
      RequestNotificationIds.fromRequestId(id),
    );
  }

  static Future<void> notificationInitCall() async {
    await requestNotificationPermission();
    await foregroundMessage();
    await _setAwesomeListeners();
    firebaseInit();
    await setupInteractMessage();
  }
}

