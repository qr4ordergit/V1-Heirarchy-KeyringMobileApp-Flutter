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

