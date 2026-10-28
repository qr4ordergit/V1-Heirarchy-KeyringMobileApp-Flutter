import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationChannels {
  static const highImportanceKey = 'high_importance_channel';

  static final highImportance = NotificationChannel(
    channelKey: highImportanceKey,
    channelName: 'Keyring Channel',
    channelDescription: 'this is Keyring channel',
    importance: NotificationImportance.Max,
    playSound: true,
    channelShowBadge: true,
    // soundSource: 'resource://raw/res_notification_sound', // no file extension
  );

  static Future<void> initAwesome() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/ic_notification',
      [highImportance],
      debug: true,
    );
  }

}


