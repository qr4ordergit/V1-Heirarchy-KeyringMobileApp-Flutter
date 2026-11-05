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

    final String title = notification?.title ?? data['title'];
    final String body = notification?.body ?? data['body'];
    // {keyring_category_id: 6acdcb39fa4a16b87a9f6a1e, keyring_category_name: 2 Fact Category, type: message, request_id: sup-ironman-473#6acdcb39fa4a16b87a9f6a1e}
    // final String title = data["request_id"].toString().split("#").first;
    // final String body = "Murli Requesting access to: \n${data["keyring_category_name"]}";

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: RequestNotificationIds.fromRequestId(requestId),
        channelKey: NotificationChannels.highImportanceKey,
        title: title,
        body: body,
        payload: message.data.map((k, v) => MapEntry(k, v.toString())),
      ),
      // actionButtons: [
      //   NotificationActionButton(
      //     key: 'ACCEPT',
      //     label: 'Accept',
      //     actionType: ActionType.SilentBackgroundAction,
      //     showInCompactView: true,
      //   ),
      //   NotificationActionButton(
      //     key: 'REJECT',
      //     label: 'Reject',
      //     actionType: ActionType.SilentBackgroundAction,
      //     isDangerousOption: true,
      //     showInCompactView: true,
      //   ),
      // ],
    );
  }
}