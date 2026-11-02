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

  // Re-initialize Awesome Notifications in this isolate (channels must exist)
  // await NotificationChannels.initAwesome();
  // await NotificationDisplay.showNotification(message);

}
// Background Show Notification Native Platform: Title: sup-ironman-473 || Body: sup-ironman-473 is requesting access to: 2 Fact Category
// It not allow to show custom data