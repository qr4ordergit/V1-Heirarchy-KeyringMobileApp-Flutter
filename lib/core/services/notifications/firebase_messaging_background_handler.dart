import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../firebase_options.dart';
import 'notification_channels.dart';
import 'notification_display.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Notification On Background: ${message.data}");


  // The background isolate has its own memory; initialize again here.
  // await NotificationChannels.initAwesome();
  // await NotificationDisplay.showNotification(message);
}

// {keyring_category_id: 12345, keyring_category_name: 2 Fact Category, body: Approve keyring?, type: message, title: New Request, request_id: sup-ironman-473#12}

