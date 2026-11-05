import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../firebase_options.dart';
import 'notification_channels.dart';
import 'notification_display.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Background Notification Data: ${message.data}");
  print("Background Notification Actual Native Platform Show Payload: Title: ${message.notification?.title} || Body: ${message.notification?.body}");

  // New isolate: channels must be registered again
  // await NotificationChannels.initAwesome();
  // await NotificationDisplay.showNotification(message);
}
