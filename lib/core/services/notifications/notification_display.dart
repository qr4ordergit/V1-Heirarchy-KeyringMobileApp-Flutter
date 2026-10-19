import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationChannels {
  static const highImportanceKey = 'high_importance_channel';

  static final highImportance = NotificationChannel(
    channelKey: highImportanceKey,
    channelName: 'Keyring Channel',
    channelDescription: 'this is Keyring channel',
    importance: NotificationImportance.Max,
    playSound: true,
    channelShowBadge: true,
  );

  static Future<void> initAwesome() async {
    await AwesomeNotifications().initialize(
      'resource://mipmap/ic_launcher',
      [highImportance],
      debug: true,
    );
  }

}

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


