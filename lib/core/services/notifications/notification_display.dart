import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_channels.dart';

class NotificationDisplay {
  static Future<void> showNotification(RemoteMessage message) async {
    final data = message.data;
    final notification = message.notification;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: (message.messageId ?? DateTime.now().toString()).hashCode & 0x7FFFFFFF,
        channelKey: NotificationChannels.highImportanceKey,
        title: notification?.title ?? data['title'],
        body: notification?.body ?? data['body'],
        payload: data.map((k, v) => MapEntry(k, v?.toString())),
        // icon: 'resource://drawable/ic_notification',
      ),
    );
  }
}

// class NotificationDisplay {
//   static Future<void> showNotification(RemoteMessage message) async {
//     final data = message.data;
//     final notification = message.notification;
//     final hasRequest = data['request_id'] != null;
//
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: (message.messageId ?? DateTime.now().toString()).hashCode & 0x7FFFFFFF,
//         channelKey: NotificationChannels.highImportanceKey,
//         title: notification?.title ?? data['title'],
//         body: notification?.body ?? data['body'],
//         payload: data.map((k, v) => MapEntry(k, v?.toString())),
//         category: NotificationCategory.Message,
//         wakeUpScreen: true,
//       ),
//       actionButtons: hasRequest
//           ? [
//         NotificationActionButton(
//           key: NotificationActions.accept,
//           label: 'Accept',
//           actionType: ActionType.SilentBackgroundAction,
//           // actionType: ActionType.Default, // opens app
//           autoDismissible: true,
//         ),
//         NotificationActionButton(
//           key: NotificationActions.reject,
//           label: 'Reject',
//           actionType: ActionType.SilentBackgroundAction,
//           // actionType: ActionType.Default,
//           isDangerousOption: true,
//           autoDismissible: true,
//         ),
//       ]
//           : null,
//     );
//   }
// }
