import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_channels.dart';
import 'request_notification_ids.dart';

class NotificationDisplay {
  static Future<void> showNotification(RemoteMessage message) async {
    final data = message.data;
    final notification = message.notification;

    final requestId = data['request_id']?.toString();

    if (requestId == null || requestId.isEmpty) {
      log('Cannot show notification: request_id is missing');
      return;
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: RequestNotificationIds.fromRequestId(requestId),
        channelKey: NotificationChannels.highImportanceKey,
        // title: data['title'],
        // body: data['body'],
        title: notification?.title ?? data['title'],
        body: notification?.body ?? data['body'],
        payload: Map<String, String>.from(
          message.data.map(
                (key, value) => MapEntry(key, value.toString()),
          ),
        ),
      ),
      // actionButtons: [
      //   NotificationActionButton(
      //     key: 'ACCEPT',
      //     label: 'Accept',
      //     actionType: ActionType.SilentBackgroundAction,
      //   ),
      //   NotificationActionButton(
      //     key: 'REJECT',
      //     label: 'Reject',
      //     actionType: ActionType.SilentBackgroundAction,
      //     isDangerousOption: true,
      //   ),
      // ],
    );
  }
}