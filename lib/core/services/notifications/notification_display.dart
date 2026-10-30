import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:keyring/core/config/app_config.dart';
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

    // final String title = notification?.title ?? data['title'];
    // final String body = notification?.body ?? data['body'];

    final String categoryName = data['keyring_category_name'] ?? '';
    final String username = data['request_id'].toString().split("#").first;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: RequestNotificationIds.fromRequestId(requestId),
        channelKey: NotificationChannels.highImportanceKey,
        title: appName,
        body: '$username is requesting access to: \n$categoryName',
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