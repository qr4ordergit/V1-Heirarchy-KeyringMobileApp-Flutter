import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../../firebase_options.dart';
import 'notification_channels.dart';
import 'notification_display.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Keyring Background Notification Data: ${message.data}");
  // {keyring_category_id: 6acdcb39fa4a16b87a9f6a1e, keyring_category_name: 2 Fact Category, type: message, title: sup-ironman-473, request_id: sup-ironman-473#6acdcb39fa4a16b87a9f6a1e}

  /// New isolate
  await NotificationChannels.initAwesome();
  await NotificationDisplay.showNotification(message);
}
